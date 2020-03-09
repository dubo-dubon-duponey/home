package docker

import (
  "loop-dev.com/shart"
	"b.l/bl"
)

Endpoint :: {
	privatekey: string
	passphrase: string
	finger?:    string
	trust:      bool | *false
	// XXX replace with validating regexp for domain_or_ip, user and port - need to crank up some RFC grammar
	user: string | *"docker"
	host: string
	port: int | *22
}

Controller :: {
	settings: {
//		{
//			controller: null
//			endpoint: Endpoint
//		} | {
			controller: Controller
			endpoint?: controller.settings.endpoint
//		}

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

		code: """
		\(settings._header)

		\(shart.logger)
		\(shart.ssh)
		\(shart.docker)
		\(shart.error)

		# Main code
		endpoint="$(get endpoint)"
		key="$(printf "%s" "$endpoint" | jq -rc .key)"
		passphrase="$(printf "%s" "$endpoint" | jq -rc .passphrase)"
		user="$(printf "%s" "$endpoint" | jq -rc .user)"
		host="$(printf "%s" "$endpoint" | jq -rc .host)"
		port="$(printf "%s" "$endpoint" | jq -rc .port)"
		finger="$(printf "%s" "$endpoint" | jq -rc 'select(.finger !=null)')"

		logger::info "Starting ssh-agent"
		ssh::boot

		logger::info "Adding identity from private key and passphrase"
		ssh::add::identity "$key" "$passphrase"

		logger::info "Adding host fingerprint"
		ssh::add::fingerprint "$finger" "$host" "$port"

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

Daemon :: Controller & {
	settings: {
		action: "logger::info \"All set. Docker Daemon happily awaiting orders on $DOCKER_HOST.\""
	}
}
