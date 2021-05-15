package debian

import (
  "duponey.cloud/types"
	"dagger.io/dagger"
	"dagger.io/dagger/op"
)

#Apt: {
	user_agent: string | * "apt-dubodubonduponey/1.0"
	extras: [...string]
}

#Image: {
	name: string | *"debian"
	registry: types.#DomainOrIP | *"index.docker.io"
	username?: dagger.#Secret
	password?: dagger.#Secret
	preflight?: string

	let _username = username

	#up: [
		if _username != _|_ {
			op.#DockerLogin & {
				target: registry
				username: _username
				secret: password
			},
		},
		op.#FetchContainer & {
			ref: "\(registry)/\(name)"
		},
		if preflight != _|_ {
			op.#Exec & {
				args: ["bash", "-c", #"""
				set -o errexit -o errtrace -o functrace -o nounset -o pipefail
				$@
				"""#, "--", preflight]
			}
		}
	]
}

#Install: {

	packages: [=~ "^[a-z0-9][a-z0-9+.-]{1,}$"]: =~ "^.+$" | bool | *true

	// XXX https://github.com/dagger/dagger/issues/466
	image: dagger.#Artifact // | * #Image

	// Extra apt configuration
	apt: #Apt

	// Hosts configuration
	let _hosts = hosts
	hosts: types.#Hosts

	// Just for debugging, ignore
	_bust: bool | *false

	#up: [
		op.#Load & {
			from: image
		},
		if len(packages) > 0 {
				op.#Exec & {
					args: ["bash", "-c", #"""
					set -o errexit -o errtrace -o functrace -o nounset -o pipefail
					apt-get update -qq "$@"
					"""#, "--", "-o", "Acquire::HTTP::User-Agent=\(apt.user_agent)"] + apt.extras
				always: _bust
				hosts: _hosts
			}
		},
		for pack, version in packages if (version & string) != _|_ {
			op.#Exec & {
				args: ["bash", "-c", #"""
          set -o errexit -o errtrace -o functrace -o nounset -o pipefail
          apt-get install -qq --no-install-recommends "$@" > /dev/null
          """#, "--", "-o", "Acquire::HTTP::User-Agent=\(apt.user_agent)"] + apt.extras + ["\(pack)=\(version)"],
				always: _bust
				hosts: _hosts
			}
		},

		for pack, version in packages if (version & true) != _|_ {
			op.#Exec & {
				args: ["bash", "-c", #"""
          set -o errexit -o errtrace -o functrace -o nounset -o pipefail
          apt-get install -qq --no-install-recommends "$@" > /dev/null
          """#, "--", "-o", "Acquire::HTTP::User-Agent=\(apt.user_agent)"] + apt.extras + [pack],
				always: _bust
				hosts: _hosts
			}
		}
	]
}
