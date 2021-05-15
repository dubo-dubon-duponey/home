package http

import (
  "duponey.cloud/types"
  "duponey.cloud/debian"
	"dagger.io/dagger/op"
)

#Request: {
	// XXX replace by proper alternate pattern when we figure out this shit
	// At least one of the two is mandatory
	url?: string
	generator?: string
	method: "PUT" | "POST" | "DELETE" | "HEAD" | "TRACE" | "PATCH" | *"GET"

	// XXX WTF cue, 200 *is* an int
	status: float
	body: string

	let _apt = apt
	let _hosts = hosts
	let _packages = packages

	apt: debian.#Apt
	hosts: types.#Hosts

	curl_args: [...string]

	packages: {
		"curl": true
		"jq": true
		"ca-certificates": true
		...
	}

	#up: [
		op.#Load & {
			from: debian.#Install & {
				image: debian.#Image
				packages: _packages
       	apt: _apt
       	hosts: _hosts
      },
		},
		if url != _|_ {
			op.#WriteFile & {
				content: url
				dest:    "/url"
				mode:    0o400
			},
		},
		if url == _|_ && generator != _|_ {
			op.#Exec & {
				args: ["bash", "-c", """
				set -o errexit -o errtrace -o functrace -o nounset -o pipefail
				\(generator) > /url
				"""]
			},
		},
		op.#Exec & {
			args: ["bash", "-c", #"""
			set -o errexit -o errtrace -o functrace -o nounset -o pipefail
			method="$1"
			url="$(cat /url)"
			shift
			curl -X "$method" -o /body --proto '=https' --tlsv1.2 -sSfL "$url" "$@"
			# XXX parse status code
			jq -n --arg body "$(cat /body)" '{"body": $body, "status": 200}' > /output
			"""#, "--", "\(method)"] + curl_args
			hosts: _hosts
			always: true
		},
		op.#Export & {
			source: "/output"
			format: "json"
		},
  ]
  ...
}

#GET: #Request

#POST: #Request & {
	method: "POST"
}

#PUT: #Request & {
	method: "PUT"
}

#PATCH: #Request & {
	method: "PATCH"
}

#DELETE: #Request & {
	method: "DELETE"
}

#HEAD: #Request & {
	method: "HEAD"
}

#TRACE: #Request & {
	method: "TRACE"
}
