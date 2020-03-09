BashDansLeCue:: {

	logger: """
		COLOR_RED=1
		COLOR_GREEN=2
		COLOR_YELLOW=3
		# Prefix a date to a log line and output to stderr
		logger::stamp(){
			local color="$1"
			local level="$2"
			local i
			shift
			shift
			[ ! "$TERM" ] || [ ! -t 2 ] || >&2 tput setaf "$color"
			for i in "$@"; do
				>&2 printf "[%s] [%s] %s\\n" "$(date)" "$level" "$i"
			done
			[ ! "$TERM" ] || [ ! -t 2 ] || >&2 tput op
		}

		logger::info(){
			logger::stamp "$COLOR_GREEN" "INFO" "$@"
		}

		logger::warning(){
			logger::stamp "$COLOR_YELLOW" "WARNING" "$@"
		}

		logger::error(){
			logger::stamp "$COLOR_RED" "ERROR" "$@"
		}
	"""

	ssh: """
		# SSH manipulation
		ssh::boot(){
			# Start ssh agent
			eval "$(ssh-agent)" > /dev/null
		}

		ssh::identity::add(){
			local key="$1"
			local password="$2"

			# Stuff in password
			touch /keypass
			chmod 700 /keypass
			printf '#!/bin/sh\\necho "%s"\\n' "$password" > /keypass

			# Add the key to the agent now
			printf "%s\\n" "$key" | SSH_ASKPASS=/keypass DISPLAY="" ssh-add - >/dev/null 2>&1
		}

		# XXX this is evil, but I'm evil
		ssh::fingerprint::add(){
			local finger="$1"
			mkdir -p ~/.ssh
			printf "%s\\n" "$finger" >> "$HOME"/.ssh/known_hosts
		}

		ssh::fingerprint::trust(){
			local host="$1"
			local port="$2"
			mkdir -p ~/.ssh
			ssh-keyscan -p "$port" -H "$host" >> ~/.ssh/known_hosts 2>/dev/null
		}
	"""

	docker: """
		# Docker
		docker::host(){
			local user="$1"
			local host="$2"
			local port="$3"
			DOCKER_HOST="$(printf "ssh://%s@%s:%s" "$user" "$host" "$port")"
			export DOCKER_HOST
		}

		docker::info(){
			docker info
		}

		docker::image::exist() {
			local name="$1"
			local tag="$2"
			[ "$(docker images -q "$name:$tag")" ] || return 1
		}

		# XXX implement pulling by digest
		docker::image::pull() {
			local name="$1"
			local tag="$2"
			docker pull "$name:$tag" > /dev/null 2>&1
		}

		docker::image::digest() {
			local name="$1"
			local tag="$2"
			local result
			result="$(docker inspect "$name:$tag" 2>/dev/null | jq -rc ".[].RepoDigests[0]")"
			printf "%s" "${result##*@}"
		}

		docker::image::id() {
			local name="$1"
			local tag="$2"
			docker inspect "$name:$tag" 2>/dev/null | jq -rc ".[].Id"
		}

		docker::image::remove(){
			local name="$1"
			local tag="$2"
			# XXX WHY DO NOT EXIT 1 ON FAILURE DOCKER CONSISTENCY DAMN IT
			docker rmi -f "$name:$tag" 2>/dev/null
		}

		docker::registry::digest() {
			local name="$1"
			local tag="$2"
			printf "" | module::run regander -s manifest HEAD "$name" "$tag" | jq -rc ".digest"
		}

		docker::container::exist() {
			local name="$1"
			[ "$(docker ps -a -q --filter "name=$name")" ] || return 1
		}

		docker::container::running() {
			local name="$1"
			[ "$(docker ps -a -q --filter "name=$name" | jq -rc ".[].State.Running")" == "true" ] || return 1
		}

		docker::container::imagedigest() {
			local name="$1"
			result="$(docker ps -a -q --filter "name=$name" | jq -rc ".[].Image")"
			printf "%s" "$result"
			[ "$result" ] || return 1
		}

		docker::container::remove(){
			local name="$1"
			docker rm -f "$name" 2>/dev/null
		}

		docker::container::run(){
			local cname="$1"
			local iname="$2"
			local itag="$3"
			local config="$4"
			local network="$5"
			local value

			local args=()
			local pargs=()

			value=$(printf "%s" "$config" | jq -rc '.readonly | select (.!=null)')
			[ ! "$value" ]	|| args+=("--read-only")

			# value=$(printf "%s" "$config" | jq -rc '.network | select(. != null)')
			# [ ! "$value" ]	||
			args+=("--net" "$network")

			value=$(printf "%s" "$config" | jq -rc '.restart | select(. != null)')
			[ ! "$value" ]  || args+=("--restart" "$value")

			value=$(printf "%s" "$config" | jq -rc '.user | select(. != null)')
			[ ! "$value" ] 	|| args+=("--user" "$value")

			args+=("--cap-drop" "ALL")
			for value in $(printf "%s" "$config" | jq -rc ".capabilities"); do
				[ "$value" == "null" ] || args+=("--cap-add" "$value")
			done

			for value in $(printf "%s" "$config" | jq -rc ".env[]"); do
				[ "$value" == "null" ] || args+=("--env" "$value")
			done

			for value in $(printf "%s" "$config" | jq -c ".command[]"); do
				[ "$value" == "null" ] || pargs+=("$value")
			done

			docker run -d "${args[@]}" --name "$cname" "$iname:$itag" "${pargs[@]}"
			# >/dev/null 2>&1
		}
	"""
	error: """
		# Errors
		export ERROR_GENERIC=1
		export ERROR_NO_SUCH_PACKAGE=2
		export ERROR_NO_DOCKER=3
		export ERROR_CUE_CASSE=4
		export ERROR_NO_SUCH_IMAGE=5
		export ERROR_NOT_IMPLEMENTED=6
		export ERROR_FAILED_STARTING=7
	"""
}
