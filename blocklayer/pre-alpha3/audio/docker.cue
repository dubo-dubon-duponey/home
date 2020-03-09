Docker:: {
	// Defines an "endpoint", eg: an host / user / ssh key referencing a running Docker daemon
	Endpoint :: {
		// Private ssh key
		privatekey: string

		// Private ssh key passphrase
		passphrase: string

		// User
		user: BlockLayer.URI.User | *"docker"
		// Hostname or ip for the Docker daemon
		host: BlockLayer.URI.DomainOrIp
		// Docker-over-ssh port
		port: BlockLayer.URI.Port | * 22

		// Optional SSH fingerprint to trust the host for
		finger?: string
		// If no fingerprint is provided, whether to blindly trust it or not
		trust: bool | *false
	}

	// A generic controller, instantiated from an endpoint, able to run arbitrary shell commands, specifically any of the docker::XXX helpers targetted at the remote host
	privateController :: Block & {
		input: false
		output: false

		settings: {
			debug: bool | *false

			endpoint: Endpoint

			action: string

			_shelldebug: string | *"+x"
			if debug {
				_shelldebug: "-x"
			}
			_header: """
			#!/usr/bin/env bash
			set \(_shelldebug) -o errexit -o errtrace -o functrace -o nounset -o pipefail
			umask 0077
			"""
		}

		code: {
			os: "alpineLinux"
			package: {
				"docker-cli": true
				"openssh-client": true
				bash: true
				jq: true
			}

			language: "bash"
			// dir:      "./docker_provider.code"
			// onChange: "onChange.sh"
			// onDestroy: "onDestroy.sh"

			script: """
			\(settings._header)

			\(BashDansLeCue.logger)
			\(BashDansLeCue.ssh)
			\(BashDansLeCue.docker)
			\(BashDansLeCue.error)

			# Main code
			endpoint="$(settings get endpoint)"
			key="$(printf "%s" "$endpoint" | jq -rc .privatekey)"
			passphrase="$(printf "%s" "$endpoint" | jq -rc .passphrase)"
			user="$(printf "%s" "$endpoint" | jq -rc .user)"
			host="$(printf "%s" "$endpoint" | jq -rc .host)"
			port="$(printf "%s" "$endpoint" | jq -rc .port)"
			trust="$(printf "%s" "$endpoint" | jq -rc .trust)"
			finger="$(printf "%s" "$endpoint" | jq -rc '.finger | select(. != null)')"

			logger::info "Starting ssh-agent"
			ssh::boot

			logger::info "Adding identity from private key and passphrase"
			ssh::identity::add "$key" "$passphrase"

			logger::info "Adding host fingerprint"
			if [ "$finger" ]; then
				logger::info "Adding provided fingerprint"
				ssh::fingerprint::add "$finger"
			elif [ "$trust" == true ]; then
				logger::warning "Blindly trusting host. You do know what you are doing, Joe, right?"
				ssh::fingerprint::trust "$host" "$port"
			else
				logger::warning "You did not provide a fingerprint, and you do not blindly trust the remote host (good) - let me fail for you, right now, so you don't have to wait."
				exit 1
			fi

			logger::info "Setting the docker host"
			docker::host "$user" "$host" "$port"

			docker::info >/dev/null 2>&1 || {
				logger::error "Failed to contact the provided docker host. Either you do not have network, or you fatfingered something."
				exit "$ERROR_NO_DOCKER"
			}

			\(settings.action)
			"""
		}
	}

	Block :: privateController & {
		settings: controller: privateController
		settings: endpoint: settings.controller.settings.endpoint
	}

	Daemon :: privateController & {
		settings: {
			action: "logger::info \"All set. Docker Daemon happily awaiting orders on $DOCKER_HOST.\""
		}
	}

	Network :: boundController & {
		settings: {
			controller: privateController
			name: string | *"hackvlan"

			driver: string | *"macvlan"

			// XXX type this properly
			subnet?: string
			gateway?: string
			ip_range?: string

	    parent?: string
  	  ipvlan_mode?: string | * "l2"

			action: """
			logger::warning "HALF_ASS IMPLEMENTATION. This will just create the network and return silently if it already exist"

			name="$(settings get name)"
			driver="$(settings get driver)"
			subnet="$(settings get subnet)"
			gateway="$(settings get gateway)"
			ip_range="$(settings get ip_range)"
			parent="$(settings get parent)"
			ipvlan_mode="$(settings get ipvlan_mode)"

			# XXX work in progress
			existing="$(docker network ls --filter "name=$name" -q)"
			if [ "$existing" ]; then
				logger::warning "We already have a network by that name. Smart change is not implemented... going to just destroy it."
				exit
				existing_specs="$(docker network inspect "$existing")"
				# XXX implement verification that the network matches the specs
				# [ "$ipvlan_mode" == $(printf "%s" "$existing_specs" | jq -rc .[0].Options.ipvlan_mode)" ]
				# "$(printf "%s" "$existing_specs" | jq -rc .[0].Options.parent)"
				# "$(printf "%s" "$existing_specs" | jq -rc .[0].Driver)"
				# "$(printf "%s" "$existing_specs" | jq -rc .[0].IPAM.Config[0].Subnet)"
				# "$(printf "%s" "$existing_specs" | jq -rc .[0].IPAM.Config[0].IPRange)"
				# "$(printf "%s" "$existing_specs" | jq -rc .[0].IPAM.Config[0].Gateway)"
			fi

			docker network create --driver "$driver" --subnet="$subnet" --ip-range="$ip_range" --gateway="$gateway" --opt ipvlan_mode="$ipvlan_mode" --opt parent="$parent" "$name"
			"""
		}
	}

	Volume :: boundController & {
		settings: {
			name: string | *"hackvlan"
			action: """
			logger::warning "XXX NOT IMPLEMENTED."
			exit 1
			"""
		}
	}

	// A Docker Image to be pulled and used on a certain Docker Daemon
	Image :: boundController & {
		settings: {
			registry: string | *"index.docker.io"
			name: string
			// XXX make sure we exclude one another and make it mandatory to have at least one
			tag?: string
			digest?: string
		}

		settings: action: """
			registry="$(settings get "registry")"
			name="$(settings get "name")"
			tag="$(settings get "tag")"
			digest="$(settings get "digest")"

			pull=true
			# XXX given that this will not run everytime, but ONLY if something changes, this is useless unfortunately
			#if docker::image::exist "$name:$tag"; then
			#	logger::info "Image $name:$tag has already been pulled on the host"
			#	pull=
			#	if [ "$(docker::registry::digest "$name" "$tag")" != "$(docker::image::digest "$name:$tag")" ]; then
			#		logger::info "Image $name:$tag is outdated. Need to remove and pull again."
			#		docker::image::remove "$name:$tag"
			#		pull=true
			#	fi
			#fi
			logger::info "Going to pull the Docker Image"
			[ ! "$pull" ] || docker::image::pull "$name" "$tag" || exit "$ERROR_NO_SUCH_IMAGE"
		"""
	}

	// A Docker Container
	Container :: boundController & {
		settings: {
			network: Docker.Network
			image: Docker.Image

			nickname: string | * "container_nick_name"

			config: {
				hostname: string | * "main_hostname"
				read_only: bool | * true
				privileged: bool | * false
				user: string | *""
				log: bool | *false
				// XXX need "IP" type as part of the blocklayer stdlib
				dns: [...string] | *[]

				station: string | *"Some advertisable name"
				command?: [...string]
				env?: [...string]
				// command: [...string] | *[]

				_hostname: "\(settings.nickname).\(settings.config.hostname)"
			}

			action: """
			logger::warning "HALF_ASS IMPLEMENTATION. This will just run the container and FAIL silently if it already exists"

			nickname="$(settings get "nickname")"
			imagename="$(settings get "image.settings.name")"
			imagetag="$(settings get "image.settings.tag")"
			config="$(settings get "config")"
			network="$(settings get "network.settings.name")"

			docker::container::run "$nickname" "$imagename" "$imagetag" "$config" "$network"
			"""
		}

		// XXX kind of a mouthful instead of a proper ternary
		// XXX some of these are never meant to be set manually - it's not obvious from a consumer perspective (eg: need "locals" instead)
		// XXX broken right now
		//{
		//	settings: privileged: true
		//	settings: container_user: "root"
		//} | {
		//	settings: privileged: false
		//	settings: container_user: settings.user
		//}

	}

}
