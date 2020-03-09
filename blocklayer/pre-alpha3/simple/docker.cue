Docker:: {
	Endpoint :: {
		privatekey: string
		passphrase: string
		finger?: string
		trust: bool | *false
		// XXX replace with validating regexp for domain_or_ip, user and port - need to crank up some RFC grammar
		user: string | *"docker"
		host: string
		port: int | * 22
	}

	Controller :: Block & {
		input: false
		output: false

		settings: {
//			{
//				controller: null
//				endpoint: Endpoint
//			} | {
				controller: Controller
				endpoint?: controller.settings.endpoint
//			}

		}

		code: {
			os: "alpineLinux"
			package: {
			}

			language: "bash"

			script: """
			"""
		}
	}

	Daemon :: Controller & {
		settings: {
			action: "logger::info \"All set. Docker Daemon happily awaiting orders on $DOCKER_HOST.\""
		}
	}

	Network :: Controller & {
		settings: {
			controller: Controller
			name: string | *"hackvlan"

			driver: string | *"macvlan"

			// XXX type this properly
			subnet?: string
			gateway?: string
			ip_range?: string

	    parent?: string
  	  ipvlan_mode?: string | * "l2"

			action: """
			logger::warning "XXX NOT IMPLEMENTED. This will only work if the network already exists"

			exit

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
			exit 1
			"""
		}
	}

	Volume :: Controller & {
		settings: {
			name: string | *"hackvlan"
			action: """
			logger::warning "XXX NOT IMPLEMENTED."
			exit 1
			"""
		}
	}

	// A Docker Image to be pulled and used on a certain Docker Daemon
	Image :: Controller & {
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
	Container :: Controller & {
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
