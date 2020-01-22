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

		ssh::add::identity(){
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
		ssh::add::fingerprint(){
			local finger="$1"
			local host="$2"
			local port="$3"
			mkdir -p ~/.ssh
			if [ "$finger" ]; then
				printf "%s\\n" "$3" >> "$HOME"/.ssh/known_hosts
			else
				ssh-keyscan -p "$port" -H "$host" >> ~/.ssh/known_hosts 2>/dev/null
			fi
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

	regander:: """
	#!/usr/bin/env bash
	##########################################################################
	# regander, docker registry shell script client
	# Released under MIT License
	# Copyright (c) 2020 dubo-dubon-duponey
	##########################################################################
	DC_VERSION="958c91d"
	DC_REVISION="958c91dc2abb1c1a7f59a620b4dc45ac9be9ec31"
	DC_BUILD_DATE="Wed, 01 Jan 2020 21:06:15 -0800"

	_have_bash(){
		local bashVersion
		if ! bashVersion="$(bash --version 2>/dev/null)"; then
			>&2 printf "[%s] %s\\n" "$(date)" "[ERROR] Dude! Amazon doesn't ship Bash on your planet?"
			exit 206
		fi
		bashVersion=${bashVersion#*version }
		bashVersion=${bashVersion%%-*}
		if [ "${bashVersion%%.*}" -lt "3" ]; then
			>&2 printf "[%s] %s\\n" "$(date)" "[ERROR] Bash is too old. Upgrade to version 3 at least to use this."
			exit 206
		fi

		readonly DC_DEPENDENCIES_V_BASH="$bashVersion"
	}

	_have_bash

	_gnu_grep(){
		if grep --version | grep -q gnu; then
			readonly _GNUGREP="true"
		fi
	}

	_gnu_grep

	# Flag parsing
	for i in "$@"
	do
		if [ "${i:0:1}" != "-" ]; then
			break
		fi
		# Get everything after the leading -
		name="${i:1}"
		# Remove a possible second char -
		[ "${name:0:1}" != "-" ] || name=${name:1}
		# Get the value, if we have an equal sign
		value=
		[[ $name == *"="* ]] && value=${name#*=}
		# Now, Get the name
		name=${name%=*}
		# Clean up the name: replace dash by underscore and uppercase everything
		name=$(printf "%s" "$name" | tr "-" "_" | tr '[:lower:]' '[:upper:]')

		# Set the variable
		_f="DC_ARGV_$name"
		declare "$_f"="$value"
		_f="DC_ARGE_$name"
		declare "$_f"=true
		# Shift the arg from the stack and move onto the next
		shift
	done

	x=0
	for i in "$@"
	do
		x=$(( x + 1 ))
		# Set the variable
		_f="DC_PARGV_$x"
		declare "$_f"="$i"
		_f="DC_PARGE_$x"
		declare "$_f"=true
	done

	# Makes the named argument mandatory on the command-line
	dc::argv::flag::validate()
	{
		local var
		local varexist
		var="DC_ARGV_$(printf "%s" "$1" | tr "-" "_" | tr '[:lower:]' '[:upper:]')"
		varexist="DC_ARGE_$(printf "%s" "$1" | tr "-" "_" | tr '[:lower:]' '[:upper:]')"
		local regexp="$2"
		local gf="${3:--E}"
		if [ "$regexp" ]; then
			if ! printf "%s" "${!var}" | grep -q "$gf" "$regexp"; then
				dc::logger::error "Flag \"$(printf "%s" "$1" | tr "_" "-" | tr '[:upper:]' '[:lower:]')\" is invalid. Must match \"$regexp\". Value is: \"${!var}\"."
				exit "$ERROR_ARGUMENT_INVALID"
			fi
		elif [ ! "${!varexist}" ]; then
			dc::logger::error "Flag \"$(printf "%s" "$1" | tr "_" "-" | tr '[:upper:]' '[:lower:]')\" is required."
			exit "$ERROR_ARGUMENT_MISSING"
		fi
	}

	dc::argv::arg::validate()
	{
		local var="DC_PARGV_$1"
		local varexist="DC_PARGE_$1"
		local regexp="$2"
		local gf="${3:--E}"
		if [ "$regexp" ]; then
			if ! printf "%s" "${!var}" | grep -q "$gf" "$regexp"; then
				dc::logger::error "Argument \"$1\" is invalid. Must match \"$regexp\". Value is: \"${!var}\"."
				exit "$ERROR_ARGUMENT_INVALID"
			fi
		elif [ ! "${!varexist}" ]; then
			dc::logger::error "Argument \"$1\" is missing."
			exit "$ERROR_ARGUMENT_MISSING"
		fi
	}

	readonly DC_COLOR_BLACK=0
	readonly DC_COLOR_RED=1
	readonly DC_COLOR_GREEN=2
	readonly DC_COLOR_YELLOW=3
	readonly DC_COLOR_BLUE=4
	readonly DC_COLOR_MAGENTA=5
	readonly DC_COLOR_CYAN=6
	readonly DC_COLOR_WHITE=7
	readonly DC_COLOR_DEFAULT=9

	readonly DC_CLI_NAME=$(basename "$0")
	readonly DC_CLI_VERSION="$DC_VERSION (core script)"
	readonly DC_CLI_LICENSE="MIT License"
	readonly DC_CLI_DESC="A fancy piece of shcript"
	export DC_CLI_USAGE=""
	export DC_CLI_OPTS=()

	# The method being called when the "help" flag is used (by default --help or -h) is passed to the script
	# Override this method in your script to define your own help
	dc::commander::help(){
		local name="$1"
		local version="$2"
		local license="$3"
		local shortdesc="$4"
		local shortusage="$5"
		local long="$6"

		dc::output::h1 "$name"
		dc::output::quote "$shortdesc"

		dc::output::h2 "Version"
		dc::output::text "$version"
		dc::output::break

		dc::output::h2 "License"
		dc::output::text "$license"
		dc::output::break

		dc::output::h2 "Usage"
		dc::output::text "$name --help"
		dc::output::break
		dc::output::text "$name --version"
		dc::output::break
		dc::output::break
		dc::output::text "$name $shortusage"
		dc::output::break
		if [ "$long" ]; then
			dc::output::h2 "Options"
			local v
			while read -r v; do
				dc::output::bullet "$v"
			done < <(printf "%s" "$long")
		fi

		dc::output::h2 "Logging control"
		dc::output::bullet "$(printf "%s" "${CLI_NAME:-${DC_CLI_NAME}}" | tr "-" "_" | tr "[:lower:]" "[:upper:]")_LOG_LEVEL=(debug|info|warning|error) will adjust logging level (default to info)"
		dc::output::bullet "$(printf "%s" "${CLI_NAME:-${DC_CLI_NAME}}" | tr "-" "_" | tr "[:lower:]" "[:upper:]")_LOG_AUTH=true will also log sensitive/credentials information (CAREFUL)"
		dc::output::break

	}

	# The method being called when the "version" flag is used (by default --version or -v) is passed to the script
	# Override this method in your script to define your own version output
	dc::commander::version(){
		printf "%s %s\\n" "$1" "$2"
	}


	dc::commander::declare::arg(){
		local number="$1"
		local validator="$2"
		local optional="$3"
		local fancy="$4"
		local description="$5"
		if [ "$_GNUGREP" ]; then
			gf="${6:--Pi}"
		else
			gf="${6:--Ei}"
		fi

		local var="DC_PARGV_$number"
		local varexist="DC_PARGE_$number"

		if [ "${DC_CLI_USAGE}" ]; then
			fancy=" $fancy"
		fi

		local long="$fancy"
		long=$(printf "%-20s" "$long")
		if [ "$optional" ]; then
			long="$long  (optional)"
		else
			long="$long            "
		fi

		DC_CLI_USAGE="${DC_CLI_USAGE}$fancy"
		DC_CLI_OPTS+=( "$long $description" )

		# If nothing was specified
		if [ ! "${!varexist}" ]; then
			# Was optional? Then just return.
			if [ "$optional" ]; then
				return
			fi
			# Asking for help or version, drop it as well
			if [ "${DC_ARGE_HELP}" ] || [ "${DC_ARGE_H}" ] || [ "${DC_ARGE_VERSION}" ]; then
				return
			fi
			# Otherwise, yeah, genuine error
			dc::logger::error "You must specify argument $1."
			exit "$ERROR_ARGUMENT_MISSING"
		fi

		if [ "$validator" ]; then
			if printf "%s" "${!var}" | grep -q "$gf" "$validator"; then
				return
			fi
			dc::logger::error "Argument \"$1\" is invalid. Must match \"$validator\". Value is: \"${!var}\"."
			exit "$ERROR_ARGUMENT_INVALID"
		fi
	}

	dc::commander::declare::flag(){
		local name="$1"
		local validator="$2"
		local optional="$3"
		local description="$4"
		local alias="$5"
		local gf
		if [ "$_GNUGREP" ]; then
			gf="${6:--Pi}"
		else
			gf="${6:--Ei}"
		fi

		local display="--$name"
		local long="--$name"
		if [ "$alias" ]; then
			display="$display/-$alias"
			long="$long, -$alias"
		fi
		if [ "$validator" ]; then
			display="$display=$validator"
			long="$long=value"
		fi
		long=$(printf "%-20s" "$long")
		if [ "$optional" ]; then
			display="[$display]"
			long="$long (optional)"
		else
			long="$long           "
		fi
		if [ "${DC_CLI_USAGE}" ]; then
			display=" $display"
		fi

		DC_CLI_USAGE="${DC_CLI_USAGE}$display"
		# XXX add padding
		DC_CLI_OPTS+=( "$long $description" )

		local m
		local mv
		m="DC_ARGE_$(printf "%s" "$name" | tr "-" "_" | tr '[:lower:]' '[:upper:]')"
		mv="DC_ARGV_$(printf "%s" "$name" | tr "-" "_" | tr '[:lower:]' '[:upper:]')"

		local s
		local sv

		if [ "$alias" ]; then
			s="DC_ARGE_$(printf "%s" "$alias" | tr '[:lower:]' '[:upper:]')"
			sv="DC_ARGV_$(printf "%s" "$alias" | tr '[:lower:]' '[:upper:]')"

			if [ "${!m}" ] && [ "${!s}" ]; then
				dc::logger::error "You cannot specify $name and $alias at the same time"
				exit "$ERROR_ARGUMENT_INVALID"
			fi
		fi

		# If nothing was specified
		if [ ! "${!m}" ] && [ ! "${!s}" ]; then
			# Was optional? Then just return.
			if [ "$optional" ]; then
				return
			fi
			# Asking for help or version, drop it as well
			if [ "${DC_ARGE_HELP}" ] || [ "${DC_ARGE_H}" ] || [ "${DC_ARGE_VERSION}" ]; then
				return
			fi
			# Otherwise, yeah, genuine error
			dc::logger::error "The flag $name must be specified."
			exit "$ERROR_ARGUMENT_MISSING"
		fi

		# We know at this point the values are not null, validate then
		if [ "$validator" ]; then
			if printf "%s" "${!mv}" | grep -q "$gf" "$validator"; then
				return
			fi
			if printf "%s" "${!sv}" | grep -q "$gf" "$validator"; then
				return
			fi
			dc::logger::error "Flag \"$(printf "%s" "$1" | tr "_" "-" | tr '[:upper:]' '[:lower:]')\" is invalid. Must match \"$validator\". Value is: \"${!var}\"."
			exit "$ERROR_ARGUMENT_INVALID"
		fi
	}

	# This is the entrypoint you should call in your script
	# It will take care of hooking the --help/-h and --version flags, and configure logging according to
	# environment variables (by default LOG_LEVEL and LOG_AUTH).
	# It will honor the "--insecure" flag to ignore TLS errors
	# It will honor the "-s/--silent" flag to silent any output to stderr
	# You should define CLI_VERSION, CLI_LICENSE, CLI_DESC and CLI_USAGE before calling init
	# You may define CLI_NAME if you want your name to be different from the script name (not recommended)
	# This method will use the *CLI_NAME*_LOG_LEVEL (debug, info, warning, error) environment variable to set the logger
	# If you want a different environment variable to be used, pass its name as the first argument
	# The same goes for the *CLI_NAME*_LOG_AUTH environment variable

	dc::commander::initialize(){
		dc::commander::declare::flag "silent" "" "optional" "silence all logging (overrides log level)" "s"
		dc::commander::declare::flag "insecure" "" "optional" "disable TLS verification for network operations"

		local loglevelvar
		local logauthvar
		loglevelvar="$(printf "%s" "${CLI_NAME:-${DC_CLI_NAME}}" | tr "-" "_" | tr "[:lower:]" "[:upper:]")_LOG_LEVEL"
		logauthvar="$(printf "%s" "${CLI_NAME:-${DC_CLI_NAME}}" | tr "-" "_" | tr "[:lower:]" "[:upper:]")_LOG_AUTH"

		[ ! "${1}" ] || loglevelvar="$1"
		[ ! "${2}" ] || logauthvar="$2"

		# If the "-s" flag is passed, mute the logger entirely
		if [ -n "${DC_ARGV_SILENT+x}" ] || [ -n "${DC_ARGV_S+x}" ]; then
			dc::configure::logger::mute
		else
			# Configure the logger from the LOG_LEVEL env variable
			case "$(printf "%s" "${!loglevelvar}" | tr '[:lower:]' '[:upper:]')" in
				DEBUG)
					dc::configure::logger::setlevel::debug
				;;
				INFO)
					dc::configure::logger::setlevel::info
				;;
				WARNING)
					dc::configure::logger::setlevel::warning
				;;
				ERROR)
					dc::configure::logger::setlevel::error
				;;
			esac
		fi

		# If the LOG_AUTH env variable is set, honor it and leak!
		if [ "${!logauthvar}" ]; then
			dc::configure::http::leak
		fi

		# If the --insecure flag is passed, allow insecure TLS connections
		if [ "${DC_ARGV_INSECURE+x}" ]; then
			dc::configure::http::insecure
		fi
	}

	dc::commander::boot(){
		# If we have been asked for --help or -h, show help
		if [ "${DC_ARGE_HELP}" ] || [ "${DC_ARGE_H}" ]; then

			local opts=
			local i
			for i in "${DC_CLI_OPTS[@]}"; do
				opts="$opts$i"$'\n'
			done

			dc::commander::help \\
				"${CLI_NAME:-${DC_CLI_NAME}}" \\
				"${CLI_VERSION:-${DC_CLI_VERSION}}" \\
				"${CLI_LICENSE:-${DC_CLI_LICENSE}}" \\
				"${CLI_DESC:-${DC_CLI_DESC}}" \\
				"${CLI_USAGE:-${DC_CLI_USAGE}}" \\
				"${CLI_OPTS:-$opts}"
			exit
		fi

		# If we have been asked for --version, show the version
		if [ "${DC_ARGE_VERSION}" ]; then
			dc::commander::version "${CLI_NAME:-${DC_CLI_NAME}}" "${CLI_VERSION:-${DC_CLI_VERSION}}"
			exit
		fi

	}

	# Thrown by dc::http::request if a network level error occurs (eg: curl exiting abnormally)
	readonly ERROR_NETWORK=200
	# Thrown if a required argument is missing
	readonly ERROR_ARGUMENT_MISSING=201
	# Thrown if an argument does not match validation
	readonly ERROR_ARGUMENT_INVALID=202
	# Should be used to convey that a certain operation is not supported
	readonly ERROR_UNSUPPORTED=203
	# Generic error to denote that the operation has failed. More specific errors may be provided instead
	readonly ERROR_FAILED=204
	# Expectations failed on a file (not readable, writable, doesn't exist, can't be created)
	readonly ERROR_FILESYSTEM=205
	# System requirements
	readonly ERROR_MISSING_REQUIREMENTS=206

	dc::fs::isfile(){
		local writable=$2
		local createifmissing=$3
		if [ "$createifmissing" ]; then
			touch "$1"
		fi
		if [ ! -f "$1" ] || [ ! -r "$1" ] || { [ "$writable" ] && [ ! -w "$1" ]; }  ; then
			dc::logger::error "You need to specify a valid file that you have access to"
			exit "$ERROR_FILESYSTEM"
		fi
	}

	dc::fs::isdir(){
		local writable=$2
		local createifmissing=$3
		if [ "$createifmissing" ]; then
			mkdir -p "$1"
		fi
		if [ ! -d "$1" ] || [ ! -r "$1" ] || { [ "$writable" ] && [ ! -w "$1" ]; }  ; then
			dc::logger::error "You need to specify a valid directory that you have access to"
			exit "$ERROR_FILESYSTEM"
		fi

	}

	#####################################
	# Configuration hooks
	#####################################

	dc::configure::http::leak(){
		dc::logger::warning "[dc-http] YOU ASKED FOR FULL-BLOWN HTTP DEBUGGING: THIS WILL LEAK YOUR AUTHENTICATION TOKENS TO STDERR."
		dc::logger::warning "[dc-http] Unless you are debugging actively and you really know what you are doing, you MUST STOP NOW."
		_DC_HTTP_REDACT=
	}

	dc::configure::http::insecure(){
		dc::logger::warning "[dc-http] YOU ARE USING THE INSECURE FLAG."
		dc::logger::warning "[dc-http] This basically means your communication with the server is as secure as if there was NO TLS AT ALL."
		dc::logger::warning "[dc-http] Unless you really, really, REALLY know what you are doing, you MUST RECONSIDER NOW."
		_DC_HTTP_INSECURE=true
	}

	#####################################
	# Public API
	#####################################

	DC_HTTP_STATUS=
	DC_HTTP_REDIRECTED=
	DC_HTTP_HEADERS=
	DC_HTTP_BODY=

	# Dumps all relevant data from the last HTTP request to the logger (warning)
	# XXX fixme: this will dump sensitive information and should be
	dc::http::dump::headers() {
		dc::logger::warning "[dc-http] status: $DC_HTTP_STATUS"
		dc::logger::warning "[dc-http] redirected to: $DC_HTTP_REDIRECTED"

		dc::logger::warning "[dc-http] headers:"

		local value

		for i in $DC_HTTP_HEADERS; do
			value=DC_HTTP_HEADER_$i

			# Expunge
			[ "$_DC_HTTP_REDACT" ] && [[ "${_DC_HTTP_PROTECTED_HEADERS[*]}" == *"$i"* ]] && value=REDACTED
			dc::logger::warning "[dc-http] $i: ${!value}"
		done
	}

	dc::http::dump::body() {
		dc::optional jq
		if ! dc::logger::warning "$(jq . $DC_HTTP_BODY 2>/dev/null)"; then
			dc::logger::warning "$(cat $DC_HTTP_BODY)"
		fi
	}

	# A helper to encode uri fragments
	dc::http::uriencode() {
		local s
		s="${*//'%'/%25}"
		s="${s//' '/%20}"
		s="${s//'"'/%22}"
		s="${s//'#'/%23}"
		s="${s//'$'/%24}"
		s="${s//'&'/%26}"
		s="${s//'+'/%2B}"
		s="${s//','/%2C}"
		s="${s//'/'/%2F}"
		s="${s//':'/%3A}"
		s="${s//';'/%3B}"
		s="${s//'='/%3D}"
		s="${s//'?'/%3F}"
		s="${s//'@'/%40}"
		s="${s//'['/%5B}"
		s="${s//']'/%5D}"
		printf %s "$s"
	}

	dc::http::request(){
		dc::require curl
		# Reset result data
		DC_HTTP_STATUS=
		DC_HTTP_REDIRECTED=
		local i
		for i in $DC_HTTP_HEADERS; do
			read -r "DC_HTTP_HEADER_$i" < <(printf "")
		done
		DC_HTTP_HEADERS=
		DC_HTTP_BODY=

		# Grab the named parameters first
		local url="$1"
		local method="${2:-HEAD}"
		local payloadFile="$3"
		shift
		shift
		shift

		# Build the curl request
		local filename
		local curlOpts=( "$url" "-v" "-L" "-s" )

		# Special case HEAD, damn you curl
		if [ "$method" == "HEAD" ]; then
			filename=/dev/null
			curlOpts[${#curlOpts[@]}]="-I"
		else
			filename="$(dc::portable::mktemp dc::http::request)"
			curlOpts[${#curlOpts[@]}]="-X"
			curlOpts[${#curlOpts[@]}]="$method"
		fi
		curlOpts[${#curlOpts[@]}]="-o$filename"

		if [ "$payloadFile" ]; then
			curlOpts[${#curlOpts[@]}]="--data-binary"
			curlOpts[${#curlOpts[@]}]="@$payloadFile"
		fi

		local i

		# Add in all remaining parameters as additional headers
		for i in "$@"; do
			curlOpts[${#curlOpts[@]}]="-H"
			curlOpts[${#curlOpts[@]}]="$i"
		done

		if [ "$_DC_HTTP_INSECURE" ]; then
			curlOpts[${#curlOpts[@]}]="--insecure"
			curlOpts[${#curlOpts[@]}]="--proxy-insecure"
		fi

		_dc::http::logcommand

		# Do it!
		local key
		local value
		local isRedirect
		local line

		while read -r i; do
			# Ignoring the leading character, and trim for content
			line=$(printf "%s" "${i:1}" | sed -E "s/^[[:space:]]*//" | sed -E "s/[[:space:]]*\\$//")
			# Ignore empty content
			[ "$line" ] || continue

			# Now, detect leading char
			case ${i:0:1} in
				">")
					# Request
				;;
				"<")
					# Response

					# This is a header
					if [[ "$line" == *":"* ]]; then
						key=$(printf "%s" "${line%%:*}" | tr "-" "_" | tr '[:lower:]' '[:upper:]')
						value=${line#*: }

						if [ ! "$isRedirect" ]; then
							[ ! "$DC_HTTP_HEADERS" ] && DC_HTTP_HEADERS=$key || DC_HTTP_HEADERS="$DC_HTTP_HEADERS $key"
							read -r "DC_HTTP_HEADER_$key" < <(printf "%s" "$value")
						elif [ "$key" == "LOCATION" ]; then
							DC_HTTP_REDIRECTED=$value
						fi

						# Expunge what we log
						[ "$_DC_HTTP_REDACT" ] && [[ "${_DC_HTTP_PROTECTED_HEADERS[*]}" == *"$key"* ]] && value=REDACTED
						dc::logger::debug "[dc-http] $key | $value"
						continue
					fi

					# Not a header, then it's a status line
					isRedirect=
					DC_HTTP_STATUS=$(printf "%s" "$line" | grep -E "^HTTP/[0-9.]+ [0-9]+")
					if [ ! "$DC_HTTP_STATUS" ]; then
						dc::logger::warning "Ignoring random curl output: $i"
						continue
					fi

					DC_HTTP_STATUS=${line#* }
					DC_HTTP_STATUS=${DC_HTTP_STATUS%% *}
					[[ ${DC_HTTP_STATUS:0:1} == "3" ]] && isRedirect=true
					dc::logger::info "[dc-http] status: $DC_HTTP_STATUS"
				;;
				"}")
					# Bytes sent
				;;
				"{")
					# Bytes received
				;;
				"*")
					# Info
				;;
			esac
			# headers[${#headers[@]}]="$t"
		done < <(
			curl "${curlOpts[@]}" 2>&1
		)
		DC_HTTP_BODY="$filename"
	}

	#####################################
	# Private
	#####################################

	_DC_HTTP_REDACT=true
	_DC_HTTP_INSECURE=
	# Given the nature of the matching we do, any header that contains these words will match, including proxy-authorization and set-cookie
	_DC_HTTP_PROTECTED_HEADERS=( authorization cookie user-agent )

	_dc::http::logcommand() {
		local output="curl"
		local i
		for i in "${curlOpts[@]}"; do
			# -args are logged as-is
			if [ "${i:0:1}" == "-" ]; then
				output="$output $i"
				continue
			fi

			# If we redact, filter out sensitive headers
			if [ "$_DC_HTTP_REDACT" ]; then
				case "${_DC_HTTP_PROTECTED_HEADERS[*]}" in
					*$(printf "%s" ${i%%:*} | tr '[:upper:]' '[:lower:]')*)
						output="$output \"${i%%:*}: REDACTED\""
						continue
					;;
				esac
			fi

			# Otherwise, pass them in
			output="$output \"$i\" "
		done

		dc::logger::info "[dc-http] ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★"
		dc::logger::info "[dc-http] $output"
		dc::logger::info "[dc-http] ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★ ★"
	}

	#####################################
	# Configuration hooks
	#####################################

	readonly DC_LOGGER_DEBUG=4
	readonly DC_LOGGER_INFO=3
	readonly DC_LOGGER_WARNING=2
	readonly DC_LOGGER_ERROR=1

	dc::configure::logger::setlevel() {
		local level="$1"
		[[ "$level" =~ ^-?[0-9]+$ ]] && [ "$level" -ge "$DC_LOGGER_ERROR" ] && [ "$level" -le "$DC_LOGGER_DEBUG" ] || level=$DC_LOGGER_DEBUG
		_DC_LOGGER_LEVEL=$level
		if [ "$_DC_LOGGER_LEVEL" == "$DC_LOGGER_DEBUG" ]; then
			dc::logger::warning "[Logger] YOU ARE LOGGING AT THE DEBUG LEVEL. This is NOT recommended for production use, and MAY LEAK sensitive information to stderr."
		fi
	}

	dc::configure::logger::setlevel::debug(){
		# XXX test this
		# Too noisy, not useful
		# set -x
		dc::configure::logger::setlevel $DC_LOGGER_DEBUG
	}

	dc::configure::logger::setlevel::info(){
		dc::configure::logger::setlevel $DC_LOGGER_INFO
	}

	dc::configure::logger::setlevel::warning(){
		dc::configure::logger::setlevel $DC_LOGGER_WARNING
	}

	dc::configure::logger::setlevel::error(){
		dc::configure::logger::setlevel $DC_LOGGER_ERROR
	}

	dc::configure::logger::mute() {
		_DC_LOGGER_LEVEL=0
	}

	#####################################
	# Public API
	#####################################

	dc::logger::debug(){
		if [ $_DC_LOGGER_LEVEL -ge $DC_LOGGER_DEBUG ]; then
			[ "$TERM" ] && [ -t 2 ] && >&2 tput setaf "$DC_COLOR_WHITE"
			local i
			for i in "$@"; do
				_dc::stamp "[DEBUG]" "$i"
			done
			[ "$TERM" ] && [ -t 2 ] && >&2 tput op
		fi
	}

	dc::logger::info(){
		if [ $_DC_LOGGER_LEVEL -ge $DC_LOGGER_INFO ]; then
			[ "$TERM" ] && [ -t 2 ] && >&2 tput setaf "$DC_COLOR_GREEN"
			local i
			for i in "$@"; do
				_dc::stamp "[INFO]" "$i"
			done
			[ "$TERM" ] && [ -t 2 ] && >&2 tput op
		fi
	}

	dc::logger::warning(){
		if [ $_DC_LOGGER_LEVEL -ge $DC_LOGGER_WARNING ]; then
			[ "$TERM" ] && [ -t 2 ] && >&2 tput setaf "$DC_COLOR_YELLOW"
			local i
			for i in "$@"; do
				_dc::stamp "[WARNING]" "$i"
			done
			[ "$TERM" ] && [ -t 2 ] && >&2 tput op
		fi
	}

	dc::logger::error(){
		if [ $_DC_LOGGER_LEVEL -ge $DC_LOGGER_ERROR ]; then
			[ "$TERM" ] && [ -t 2 ] && >&2 tput setaf "$DC_COLOR_RED"
			local i
			for i in "$@"; do
				_dc::stamp "[ERROR]" "$i"
			done
			[ "$TERM" ] && [ -t 2 ] && >&2 tput op
		fi
	}

	#####################################
	# Private helpers
	#####################################

	_DC_LOGGER_LEVEL=$DC_LOGGER_INFO

	# Prefix a date to a log line and output to stderr
	_dc::stamp(){
		>&2 printf "[%s] %s\\n" "$(date)" "$*"
	}


	export DC_STYLE_H1_START=( bold smul "setaf $DC_COLOR_WHITE" )
	export DC_STYLE_H1_END=( sgr0 rmul op )

	export DC_STYLE_H2_START=( bold smul "setaf $DC_COLOR_WHITE" )
	export DC_STYLE_H2_END=( sgr0 rmul op )

	export DC_STYLE_EMPHASIS_START=bold
	export DC_STYLE_EMPHASIS_END=sgr0

	export DC_STYLE_STRONG_START=( bold "setaf $DC_COLOR_RED" )
	export DC_STYLE_STRONG_END=( sgr0 op )

	export DC_STYLE_RULE_START=( bold smul )
	export DC_STYLE_RULE_END=( sgr0 rmul )

	export DC_STYLE_QUOTE_START=bold
	export DC_STYLE_QUOTE_END=sgr0

	# Centering is tricky to get right with unicode chars - both wc and printf will count octets...
	dc::output::h1(){
		local i="$1"

		local width
		width=$(tput cols)

		local even
		local ln

		ln=${#i}
		even=$(( (ln + width) & 1 ))

		printf "\\n"
		printf " %.s" $(seq -s" " $(( width / 4 )))
		_dc::style H1_START
		printf " %.s" $(seq -s" " $(( width / 4 )))
		printf " %.s" $(seq -s" " $(( width / 4 )))
		_dc::style H1_END
		printf " %.s" $(seq -s" " $(( width / 4 + even )))
		printf "\\n"

		printf " %.s" $(seq -s" " $(( (width - ln) / 2)))
		printf "%s" "$i" | tr '[:lower:]' '[:upper:]'
		printf " %.s" $(seq -s" " $(( (width - ln) / 2)))
		printf "\\n"
		printf "\\n"
	}

	dc::output::h2(){
		local i="$1"

		local width
		width=$(tput cols)

		printf "\\n"
		printf "  "

		_dc::style H2_START
		printf "%s" "  $i"
		printf " %.s" $(seq -s" " $(( width / 2 - ${#i} - 4 )))
		_dc::style H2_END

		printf "\\n"
		printf "\\n"
	}

	dc::output::emphasis(){
		_dc::style EMPHASIS_START
		local i
		for i in "$@"; do
			printf "%s " "$i"
		done
		_dc::style EMPHASIS_END
	}

	dc::output::strong(){
		_dc::style STRONG_START
		local i
		for i in "$@"; do
			printf "%s " "$i"
		done
		_dc::style STRONG_END
	}

	dc::output::bullet(){
		local i
		for i in "$@"; do
			printf "    • %s\\n" "$i"
		done
	}

	#dc::output::code(){
	#}

	#dc::output::table(){
	#}

	dc::output::quote(){
		_dc::style QUOTE_START
		local i
		for i in "$@"; do
			printf "  > %s\\n" "$i"
		done
		_dc::style QUOTE_END
	}

	dc::output::text(){
		local i
		printf "    "
		for i in "$@"; do
			printf "%s " "$i"
		done
	}

	dc::output::rule(){
		_dc::style RULE_START
		local width
		width=$(tput cols)
		printf " %.s" $(seq -s" " "$width")
		_dc::style RULE_END
	}

	dc::output::break(){
		printf "\\n"
	}

	dc::output::json() {
		dc::optional "$_DC_OUTPUT_JSON_JQ"

		# Print through jq and return
		if printf "%s" "$1" | "$_DC_OUTPUT_JSON_JQ" "." 2>/dev/null; then
			return
		fi

		# Failed... do we have jq? If not, just echo the stuff and pray
		if [ ! "$_DC_DEPENDENCIES_B_JQ" ]; then
			printf "%s" "$1"
			return
		fi

		# Otherwise, that means the stuff was not json. Error out.
		dc::logger::error "Provided input is NOT valid json:"
		dc::logger::error "$1"
		exit "$ERROR_ARGUMENT_INVALID"
	}

	###############################
	# Private helpers
	###############################

	# Private hook to ease testing
	_DC_OUTPUT_JSON_JQ=jq

	_dc::style(){
		local vName="DC_STYLE_$1[@]"
		local i
		for i in "${!vName}"; do
			# shellcheck disable=SC2086
			[ "$TERM" ] && [ -t 1 ] && >&1 tput $i
		done
	}

	##########################################################################
	# For internal use only
	# ------
	# This is meant to provide portable code for system operation calling on
	# binaries which implementations vary too significantly.
	##########################################################################

	dc::portable::mktemp(){
		mktemp -q "${TMPDIR:-/tmp}/$1.XXXXXX" 2>/dev/null || mktemp -q
	}

	dc::portable::base64d(){
		case "$(uname)" in
			Darwin)
				base64 -D
			;;
			*)
				base64 -d
			;;
		esac
	}

	dc::prompt::question() {
		local message="$1"
		if [ ! -t 2 ] || [ ! -t 0 ]; then
			return
		fi

		read -r -p "$message" "$2"
	}

	dc::prompt::confirm(){
		# XXX Use bel and flash
		if [ ! -t 2 ] || [ ! -t 0 ]; then
			return
		fi

		read -r
	}

	dc::prompt::credentials() {
		# TODO implement osxkeychain integration
		# No terminal stdin or stdout, can't ask for credentials
		if [ ! -t 2 ] || [ ! -t 0 ]; then
			return
		fi

		# No username? Then ask for one.
		read -r -p "$1" "$2"
		# No answer? Stay anonymous
		if [ ! "${!2}" ]; then
			return
		fi

		# Otherwise, ask for password
		read -r -s -p "$3" "$4"
		# Just to avoid garbling the output
		>&2 printf "\\n"
	}

	readonly DC_PLATFORM_MAC=Darwin
	readonly DC_PLATFORM_LINUX=Linux

	dc::require::platform(){
		if [[ "$*" != *"$(uname)"* ]]; then
			dc::logger::error "Sorry, your platform $(uname) is not supported by this."
			exit "$ERROR_MISSING_REQUIREMENTS"
		fi
	}

	dc::require::platform::mac(){
		if [ "$(uname)" != "$DC_PLATFORM_MAC" ]; then
			dc::logger::error "This is working only on mac, sorry."
			exit "$ERROR_MISSING_REQUIREMENTS"
		fi
	}

	dc::require::platform::linux(){
		if [ "$(uname)" != "$DC_PLATFORM_LINUX" ]; then
			dc::logger::error "This is working only on linux, sorry."
			exit "$ERROR_MISSING_REQUIREMENTS"
		fi
	}

	dc::require(){
		local binary="$1"
		local versionFlag="$2"
		local version="$3"
		local varname
		varname=_DC_DEPENDENCIES_B_$(printf "%s" "$binary" | tr '[:lower:]' '[:upper:]')
		if [ ! ${!varname+x} ]; then
			if ! command -v "$binary" >/dev/null; then
				dc::logger::error "You need $binary for this to work."
				exit "$ERROR_MISSING_REQUIREMENTS"
			fi
			read -r "${varname?}" < <(printf "true")
		fi
		if [ ! "$versionFlag" ]; then
			return
		fi
		varname=DC_DEPENDENCIES_V_$(printf "%s" "$binary" | tr '[:lower:]' '[:upper:]')
		if [ ! ${!varname+x} ]; then
			while read -r "${varname?}"; do
				if printf "%s" "${!varname}" | grep -qE "^[^0-9.]*([0-9]+[.][0-9]+).*"; then
					break
				fi
			# XXX interestingly, some application will output the result on stdout (jq version 1.3 is such an example)
			# This is broken behavior, that we do not try to workaround here
			done < <($binary "$versionFlag" 2>/dev/null)
			read -r "${varname?}" < <(printf "%s" "${!varname}" | sed -E 's/^[^0-9.]*([0-9]+[.][0-9]+).*/\\1/')
		fi
		if [[ "$version" > "${!varname}" ]]; then
			dc::logger::error "You need $binary (version >= $version) for this to work (you currently have ${!varname})."
			exit "$ERROR_MISSING_REQUIREMENTS"
		fi
	}

	dc::optional(){
		local binary="$1"
		local versionFlag="$2"
		local version="$3"
		local varname
		varname=_DC_DEPENDENCIES_B_$(printf "%s" "$binary" | tr '[:lower:]' '[:upper:]')
		if [ ! ${!varname+x} ]; then
			if ! command -v "$binary" >/dev/null; then
				dc::logger::warning "Optional binary $binary is recommended for this."
				return
			fi
			read -r "${varname?}" < <(printf "true")
		fi
		if [ ! "$versionFlag" ]; then
			return
		fi
		varname=DC_DEPENDENCIES_V_$(printf "%s" "$binary" | tr '[:lower:]' '[:upper:]')
		if [ ! ${!varname+x} ]; then
			while read -r "${varname?}"; do
				if printf "%s" "${!varname}" | grep -qE "^[^0-9.]*([0-9]+[.][0-9]+).*"; then
					break
				fi
			done < <($binary "$versionFlag" 2>/dev/null)
			read -r "${varname?}" < <(printf "%s" "${!varname}" | sed -E 's/^[^0-9.]*([0-9]+[.][0-9]+).*/\\1/')
		fi
		if [[ "$version" > "${!varname}" ]]; then
			dc::logger::warning "Optional $binary (version >= $version) is recommended, but you have it as ${!varname})."
		fi
	}

	# https://golang.org/pkg/strings/#Split
	dc::string::split(){
		dc::string::splitN "$1" "$2" -1
	}

	# https://golang.org/pkg/strings/#SplitN
	dc::string::splitN(){
		local _dcss_subject=${!1}
		local sep="${!2}"
		local _dcss_count
		_dcss_count="$(printf "%s" "$3" | grep -E '^[0-9-]+$')"
		_dcss_count=${_dcss_count:--1}

		if [ "$_dcss_count" == 0 ]; then
			# Should return nil
			return
		fi
		if [ ! "${_dcss_subject}" ]; then
			# Should return an empty array
			return
		fi

		# No sep, split on every single char
		if [ ! "$sep" ]; then
			local i
			for (( i=0; i<${#_dcss_subject} && (_dcss_count == -1 || i<_dcss_count); i++)); do
				printf "%s\\0" "${_dcss_subject:$i:1}"
			done
			return
		fi

		# Otherwise
		local count=1
		local _dcss_segment
		while
			_dcss_segment="${_dcss_subject%%"$sep"*}"
			[ "${#_dcss_segment}" != "${#_dcss_subject}" ] && { [ "$_dcss_count" == -1 ] || [ "$count" -lt "$_dcss_count" ]; }
		do
			printf "%s\\0" "$_dcss_segment"
			local tt=$(( ${#_dcss_segment} + ${#sep} ))
			_dcss_subject=${_dcss_subject:${tt}}
			count=$(( count + 1 ))
		done
		printf "%s\\0" "$_dcss_subject"
	}

	# https://golang.org/pkg/strings/#Join
	dc::string::join(){
		local varname="$1[@]"
		local i
		local sep=
		for i in "${!varname}"; do
			printf "%s" "$sep" "$i"
			sep="$2"
		done
	}

	# ***************** OK
	dc::string::toLower(){
		if [ ! "${1}" ]; then
			tr '[:upper:]' '[:lower:]' < /dev/stdin
		else
			printf "%s" "${!1}" | tr '[:upper:]' '[:lower:]'
		fi
	}

	# ***************** OK
	dc::string::toUpper(){
		if [ ! "${1}" ]; then
			tr '[:lower:]' '[:upper:]' < /dev/stdin
		else
			printf "%s" "${!1}" | tr '[:lower:]' '[:upper:]'
		fi
	}

	# ***************** OK
	dc::string::trimSpace(){
		if [ ! "${1}" ]; then
			sed -E "s/^[[:space:]\\n]*//" < /dev/stdin | sed -E "s/[[:space:]\\n]*\\$//"
		else
			printf "%s" "${!1}" | sed -E "s/^[[:space:]\\n]*//" | sed -E "s/[[:space:]\\n]*\\$//"
		fi
	}

	readonly DC_VERSION=${DC_VERSION:-unknown}
	readonly DC_REVISION=${DC_REVISION:-unknown}
	readonly DC_BUILD_DATE=${DC_BUILD_DATE:-unknown}

	dc-ext::http-cache::init(){
		dc-ext::sqlite::ensure "dchttp" "method TEXT, url TEXT, content BLOB, PRIMARY KEY(method, url)"
	}

	dc-ext::http-cache::request(){
		local url="$1"
		local method="$2"
		local result
		result=$(dc-ext::sqlite::select "dchttp" "content" "method='$method' AND url='$url'")
		DC_HTTP_CACHE=miss
		if [ ! "$result" ]; then
			dc::http::request "$url" "$method"
			if [ "$DC_HTTP_STATUS" != 200 ]; then
				dc::logger::error "Failed fetching for $url"
				exit "$ERROR_NETWORK"
			fi
			if [ "$DC_HTTP_STATUS" == 200 ]; then
				result="$(base64 "$DC_HTTP_BODY")"
				dc-ext::sqlite::insert "dchttp" "url, method, content" "'$url', '$method', '$result'"
				DC_HTTP_BODY="$result"
				# "$(cat $DC_HTTP_BODY)"
			fi
		else
			DC_HTTP_STATUS=200
			export DC_HTTP_CACHE=hit
			DC_HTTP_BODY="$result" # $(echo $result | dc::portable::base64d)"
		fi

	}


	DC_JWT_TOKEN=
	DC_JWT_HEADER=
	DC_JWT_PAYLOAD=
	DC_JWT_ACCESS=

	dc::jwt::read(){
		dc::require jq

		export DC_JWT_TOKEN="$1"

		local decoded
		read -r -a decoded< <(printf "%s" "$1" | tr "." " ")
		#local sig

		# XXX WTFFFFF base64
		if ! DC_JWT_HEADER="$(printf "%s" "${decoded[0]}==" | dc::portable::base64d 2>/dev/null)"; then
			DC_JWT_HEADER="$(printf "%s" "${decoded[0]}" | dc::portable::base64d)"
		fi
		if ! DC_JWT_PAYLOAD="$(printf "%s" "${decoded[1]}==" | dc::portable::base64d 2>/dev/null)"; then
			DC_JWT_PAYLOAD="$(printf "%s" "${decoded[1]}" | dc::portable::base64d)"
		fi
		#sig=$(printf "%s" ${decoded[2]}== | dc::portable::base64d 2>/dev/null)
		#if [[ $? != 0 ]]; then
		#  sig=$(printf "%s" ${decoded[2]} | dc::portable::base64d)
		#fi

		if [ ! "$_DC_HTTP_REDACT" ]; then
			dc::logger::debug "[dc-jwt] decoded header: $(printf "%s" "$DC_JWT_HEADER" | jq '.')"
			dc::logger::debug "[dc-jwt] decoded payload: $(printf "%s" "$DC_JWT_PAYLOAD" | jq '.')"
			# TODO implement signature verification? not super useful...
			# dc::logger::debug "[JWT] sig: $(printf "%s" $sig)"
		fi

		# Grab the access response
		export DC_JWT_ACCESS
		DC_JWT_ACCESS="$(printf "%s" "$DC_JWT_PAYLOAD" | jq '.access')"
		dc::logger::debug "[dc-jwt] access for: $DC_JWT_ACCESS"
	}

	# XXX this is a POC implementation
	# Input is NOT sanitized, and very likely to be prone to injections if left unchecked
	# Do NOT rely on this for anything sensitive

	_DC_EXT_SQLITE_DB=

	dc-ext::sqlite::init(){
		dc::require sqlite3
		mkdir -p "$(dirname "$1")"
		_DC_EXT_SQLITE_DB="$1"
	}

	#_dc-ext::sqlite::cmd(){
	#  result=$(echo "$1" | sqlite3 "$_DC_EXT_SQLITE_DB")
	#}

	dc-ext::sqlite::ensure(){
	# echo "create table if not exists testable (method TEXT, url TEXT, content BLOB, PRIMARY KEY(method, url))" | sqlite3 test.db
		local table="$1"
		local description="$2"
		printf "%s" "create table if not exists $table ($description);" | sqlite3 "$_DC_EXT_SQLITE_DB"
	}

	dc-ext::sqlite::select(){
		local table="$1"
		printf "%s" "select $2 from $table where $3;" | sqlite3 "$_DC_EXT_SQLITE_DB"
	}

	dc-ext::sqlite::insert(){
		local table="$1"
		local fields="$2"
		local values="$3"
		shift
		shift
		printf "%s" "INSERT INTO $table ($fields) VALUES ($values);" | sqlite3 "$_DC_EXT_SQLITE_DB"
	}

	dc-ext::sqlite::delete(){
		local table="$1"
		local condition="$2"
		printf "%s" "DELETE from $table where $condition;" | sqlite3 "$_DC_EXT_SQLITE_DB"
	}

	#####################################
	# High-level registry API
	#####################################

	_expect(){
		local expect="$1"
		if [ "$DC_HTTP_STATUS" != "$expect" ]; then
			dc::logger::error "Was expecting status code $expect, received $DC_HTTP_STATUS"
			dc::http::dump::headers
			dc::http::dump::body
			exit "$ERROR_REGISTRY_UNKNOWN"
		fi
	}

	regander::version::GET(){
		# XXX technically, the version is present even when authentication fails
		# This method will still make authentication mandatory
		_regander::client "" GET ""

		if [ "$DC_HTTP_HEADER_DOCKER_DISTRIBUTION_API_VERSION" != "registry/2.0" ]; then
			dc::logger::error "This server doesn't support the Registry API (returned version header was: \\"$DC_HTTP_HEADER_DOCKER_DISTRIBUTION_API_VERSION)\\""
			exit "$ERROR_SERVER_NOT_WHAT_YOU_THINK"
		fi

		dc::logger::info "GET version successful: \\"$DC_HTTP_HEADER_DOCKER_DISTRIBUTION_API_VERSION\\""
		dc::logger::debug "$(jq '.' "$DC_HTTP_BODY" 2>/dev/null || cat "$DC_HTTP_BODY")"

		dc::output::json "\\"$DC_HTTP_HEADER_DOCKER_DISTRIBUTION_API_VERSION\\""
	}

	regander::catalog::GET() {
		_regander::client "_catalog" GET ""

		dc::logger::info "GET catalog successful"
		dc::logger::debug "$(jq '.' "$DC_HTTP_BODY" 2>/dev/null || cat "$DC_HTTP_BODY")"

		jq '.' "$DC_HTTP_BODY"
	}

	regander::tags::GET() {
		local name="$1"

		_regander::client "$name/tags/list" GET ""

		dc::logger::info "GET tagslist successful"
		dc::logger::debug "$(jq '.' "$DC_HTTP_BODY" 2>/dev/null || cat "$DC_HTTP_BODY")"

		jq '.' "$DC_HTTP_BODY"
	}

	regander::manifest::HEAD() {
		local name="$1"
		local ref="${2:-latest}"

		_regander::client "$name/manifests/$ref" HEAD ""

		dc::logger::info "HEAD manifest successful"
		dc::logger::debug " * Has a length of: $DC_HTTP_HEADER_CONTENT_LENGTH bytes"
		dc::logger::debug " * Is of content-type: $DC_HTTP_HEADER_CONTENT_TYPE"
		dc::logger::debug " * Has digest: $DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST"

		dc::output::json "{\\"type\\": \\"$DC_HTTP_HEADER_CONTENT_TYPE\\", \\"length\\": \\"$DC_HTTP_HEADER_CONTENT_LENGTH\\", \\"digest\\": \\"$DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST\\"}"
	}

	regander::manifest::GET() {
		local name=$1
		local ref=${2:-latest} # Tag or digest

		_regander::client "$name/manifests/$ref" GET ""

		dc::logger::info "GET manifest successful"
		dc::logger::debug " * Has a length of: $DC_HTTP_HEADER_CONTENT_LENGTH bytes"
		dc::logger::debug " * Is of content-type: $DC_HTTP_HEADER_CONTENT_TYPE"
		dc::logger::debug " * Has digest: $DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST"

		dc::logger::debug "$(jq '.' "$DC_HTTP_BODY" 2>/dev/null || cat "$DC_HTTP_BODY")"

		# Digest verification
		[ "$REGANDER_NO_VERIFY" ] || regander::shasum::verify "$DC_HTTP_BODY" "$DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST"

		# Return the body EXACTLY as-is
		cat "$DC_HTTP_BODY"
	}

	regander::manifest::PUT() {
		local name="$1"
		local ref="${2:-latest}"

		if [ -t 0 ]; then
			dc::logger::warning "Type or copy / paste your manifest below, then press enter, then CTRL+D to send it"
		fi

		# TODO schema validation?
		local payload
		local raw

		raw="$(cat /dev/stdin)"
		if ! payload="$(printf "%s" "$raw" | jq -c -j . 2>/dev/null)" || [ ! "$payload" ]; then
			dc::logger::error "The provided payload is not valid json... not sending. check your input: $raw"
			exit "$ERROR_REGISTRY_MALFORMED"
		fi

		local mime
		mime="$(printf "%s" "$payload" | jq -rc .mediaType 2>/dev/null)"
		# No embedded mime-type means that may be a v1 thingie
		if [ ! "$mime" ]; then
			mime=$MIME_MANIFEST_V1
		fi
		# XXX shaky - a mime type that would partially match a substring would pass
		if [[ "${REGANDER_ACCEPT[*]}" != *"$mime"* ]]; then
			dc::logger::error "Mime type $mime is not recognized as a valid type."
			exit "$ERROR_ARGUMENT_INVALID"
		fi

		local shasum
		shasum=$(regander::shasum::compute /dev/stdin < <(printf "%s" "$raw"))

		dc::logger::info "Shasum for content is $shasum. Going to push to $name/manifests/$ref."

		_regander::client "$name/manifests/$ref" PUT "$raw" "Content-type: $mime"

		_expect 201

		dc::logger::info "PUT manifest successful"
		dc::logger::debug " * Location: $DC_HTTP_HEADER_LOCATION"
		dc::logger::debug " * Digest: $DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST"

		dc::output::json "{\\"location\\": \\"$DC_HTTP_HEADER_LOCATION\\", \\"digest\\": \\"$DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST\\"}"
	}

	regander::manifest::DELETE() {
		local name="$1"
		local ref="${2:-latest}"

		_regander::client "$name/manifests/$ref" DELETE ""

		_expect 202
	}

	regander::blob::HEAD() {
		# Restrict to digest
		dc::commander::declare::arg 4 "$GRAMMAR_DIGEST_SHA256"

		local name="$1"
		local ref="$2" # digest

		_regander::client "$name/blobs/$ref" HEAD ""

		dc::logger::info "HEAD blob successful"
		dc::logger::debug " * Has a length of: $DC_HTTP_HEADER_CONTENT_LENGTH bytes"
		dc::logger::debug " * Is of content-type: $DC_HTTP_HEADER_CONTENT_TYPE"

		local finally="$name/blobs/$ref"
		if [ "$DC_HTTP_REDIRECTED" ]; then
			finally=$DC_HTTP_REDIRECTED
		fi
		if [ "$_DC_HTTP_REDACT" ]; then
			dc::logger::debug " * Final location: REDACTED" # $finally
		else
			# Careful, this is possibly leaking a valid signed token to access private content
			dc::logger::debug " * Final location: $finally"
		fi
		dc::output::json "{\\"type\\": \\"$DC_HTTP_HEADER_CONTENT_TYPE\\", \\"length\\": \\"$DC_HTTP_HEADER_CONTENT_LENGTH\\", \\"location\\": \\"$finally\\"}"
	}

	regander::blob::GET() {
		# Restrict to digest
		dc::commander::declare::arg 4 "$GRAMMAR_DIGEST_SHA256"

		local name="$1"
		local ref="$2" # digest

		_regander::client "$name/blobs/$ref" HEAD ""

		dc::logger::info "GET blob successful"
		dc::logger::debug " * Has a length of: $DC_HTTP_HEADER_CONTENT_LENGTH bytes"
		dc::logger::debug " * Is of content-type: $DC_HTTP_HEADER_CONTENT_TYPE"

		if [ "$DC_HTTP_REDIRECTED" ]; then
			if [ "$_DC_HTTP_REDACT" ]; then
				dc::logger::debug " * Final location: REDACTED" # $finally
			else
				# Careful, this is possibly leaking a valid signed token to access private content
				dc::logger::debug " * Final location: $DC_HTTP_REDIRECTED"
			fi
			_regander::anonymous "$DC_HTTP_REDIRECTED" "GET" ""
		else
			_regander::client "$name/blobs/$ref" "GET" ""
		fi

		dc::logger::debug "About to verify shasum"
		[ "$REGANDER_NO_VERIFY" ] || regander::shasum::verify "$DC_HTTP_BODY" "$ref"
		dc::logger::debug "Verification done"
		# echo "$DC_HTTP_BODY"
		dc::logger::debug "About to cat $DC_HTTP_BODY"
		cat "$DC_HTTP_BODY"
		# dc::logger::debug "Done catting"
	}

	regander::blob::MOUNT() {
		# Restrict to digest
		dc::commander::declare::arg 4 "$GRAMMAR_DIGEST_SHA256"

		local name="$1"
		local ref="$2"
		local from="$3"

		_regander::client "$name/blobs/uploads/?mount=$ref&from=$from" POST ""

		_expect 201

		dc::logger::info "MOUNT blob successful"
		dc::logger::debug " * Location: $DC_HTTP_HEADER_LOCATION"
		dc::logger::debug " * Digest: $DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST"
		dc::logger::debug " * Length: $DC_HTTP_HEADER_CONTENT_LENGTH"
		dc::output::json "{\\"location\\": \\"$DC_HTTP_HEADER_LOCATION\\", \\"length\\": \\"$DC_HTTP_HEADER_CONTENT_LENGTH\\", \\"digest\\": \\"$DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST\\"}"
	}

	regander::blob::DELETE() {
		# Restrict to digest
		dc::commander::declare::arg 4 "$GRAMMAR_DIGEST_SHA256"

		local name="$1"
		local ref="$2" # digest DELETE /v2/<name>/blobs/<digest>

		_regander::client "$name/blobs/$ref" DELETE ""

		_expect 202
	}

	regander::blob::PUT() {
		local name=$1
		local type=$2

		# Get an upload id
		_regander::client "$name/blobs/uploads/" POST ""

		_expect 202

		# XXX sucks - need to things clean-up also wrt curl instead of flipping out files all over the place
		tmpfile=$(mktemp -t regander::blob::PUT)
		cat /dev/stdin > "$tmpfile"

		# Now do a monolithic PUT
		local digest
		local length
		digest="$(regander::shasum::compute "$tmpfile")"
		length=$(wc -c "$tmpfile" | awk '{print $1}')

		_regander::straightwithauth "$DC_HTTP_HEADER_LOCATION&digest=$digest" PUT "$tmpfile" \\
			"Content-Type: application/octet-stream" \\
			"Content-Length: $length"

		_expect 201
		dc::output::json "{\\"digest\\": \\"$DC_HTTP_HEADER_DOCKER_CONTENT_DIGEST\\", \\"size\\": $length, \\"mediaType\\": \\"$type\\"}"
	}

	readonly PLATFORM_OS_ANDROID=android
	readonly PLATFORM_OS_DARWIN=darwin
	readonly PLATFORM_OS_DRAGONFLY=dragonfly
	readonly PLATFORM_OS_FREEBSD=freebsd
	readonly PLATFORM_OS_LINUX=linux
	readonly PLATFORM_OS_NETBSD=netbsd
	readonly PLATFORM_OS_OPENBSD=openbsd
	readonly PLATFORM_OS_PLAN9=plan9
	readonly PLATFORM_OS_SOLARIS=solaris
	readonly PLATFORM_OS_WINDOWS=windows
	readonly PLATFORM_OSES=( "$PLATFORM_OS_ANDROID" "$PLATFORM_OS_DARWIN" "$PLATFORM_OS_DRAGONFLY" "$PLATFORM_OS_FREEBSD" "$PLATFORM_OS_LINUX" "$PLATFORM_OS_NETBSD" "$PLATFORM_OS_OPENBSD" "$PLATFORM_OS_PLAN9" "$PLATFORM_OS_SOLARIS" "$PLATFORM_OS_WINDOWS" )

	readonly PLATFORM_ARCH_386=386
	readonly PLATFORM_ARCH_AMD64=amd64
	readonly PLATFORM_ARCH_ARM=arm
	readonly PLATFORM_ARCH_ARM64=arm64
	readonly PLATFORM_ARCH_PPC64=ppc64
	readonly PLATFORM_ARCH_PPC64LE=ppc64le
	readonly PLATFORM_ARCH_MIPS=mips
	readonly PLATFORM_ARCH_MIPSLE=mipsle
	readonly PLATFORM_ARCH_MIPS64=mips64
	readonly PLATFORM_ARCH_MIPS64LE=mips64le
	readonly PLATFORM_ARCH_S390X=s390x
	readonly PLATFORM_ARCHES=( "$PLATFORM_ARCH_386" "$PLATFORM_ARCH_AMD64" "$PLATFORM_ARCH_ARM" "$PLATFORM_ARCH_ARM64" "$PLATFORM_ARCH_PPC64" "$PLATFORM_ARCH_PPC64LE" "$PLATFORM_ARCH_MIPS" "$PLATFORM_ARCH_MIPSLE" "$PLATFORM_ARCH_MIPS64" "$PLATFORM_ARCH_MIPS64LE" "$PLATFORM_ARCH_S390X" )

	readonly PLATFORM_VARIANT_V6=v6
	readonly PLATFORM_VARIANT_V7=v7
	readonly PLATFORM_VARIANT_V8=v8
	readonly PLATFORM_VARIANTS=( "$PLATFORM_VARIANT_V6" "$PLATFORM_VARIANT_V7" "$PLATFORM_VARIANT_V8" )

	# Depends on:
	# REGANDER_ACCEPT
	# REGANDER_UA
	# REGANDER_REGISTRY
	# REGANDER_USERNAME
	# REGANDER_PASSWORD

	_regander::straightwithauth(){
		local url="$1"
		local method="$2"
		local payload="$3"
		shift
		shift
		shift
		local auth=
		# For first try, always use any existing token
		if [ "$DC_JWT_TOKEN" ]; then
			auth="Authorization: Bearer $DC_JWT_TOKEN"
		fi

		# Do the request
		if [ "$payload" ]; then
			_wrapper::request "$url" "$method" "-" "$auth" "$@" < "$payload"
		else
			_wrapper::request "$url" "$method" "" "$auth" "$@"
		fi
	}

	_regander::anonymous(){
		_wrapper::request "$@"
		_wrapper::request::postprocess
	}

	# Simple wrapper around the actual client that deals with some error conditions, plus UA and Accept header
	_regander::client(){
		_regander::http "$REGANDER_REGISTRY/$1" "${@:2}"
		_wrapper::request::postprocess
	}

	#####################################
	# Authentication helper
	#####################################
	_regander::authenticate() {
		# Query the auth server (1) for the service (2) with scope (3)
		local url="${1}?service=${2}"
		local scope="$3"
		shift
		shift
		shift

		# Why on earth is garant not able to take a single scope param with spaces? this is foobared Docker!
		for i in $scope; do
			url="$url&scope=$(dc::http::uriencode "$i")"
		done

		# SO...
		while true; do
			local authHeader=
			# Fetch credentials, if we don't have some to replay already
			if [ ! "$REGANDER_USERNAME" ]; then
				dc::prompt::credentials "Please provide your username (or press enter for anonymous): " REGANDER_USERNAME "password: " REGANDER_PASSWORD
				export REGANDER_USERNAME
				export REGANDER_PASSWORD
			fi

			# If we have something, build the basic auth header
			if [ "$REGANDER_USERNAME" ]; then
				# Generate the basic auth token with the known user
				authHeader="Basic $(printf "%s" "${REGANDER_USERNAME}:${REGANDER_PASSWORD}" | base64)"
			fi

			# Query the service
			dc::http::request "$url" GET "" "Authorization: $authHeader" "User-Agent: $REGANDER_UA" "$@"

			if [ "$DC_HTTP_STATUS" == "401" ]; then
				dc::logger::warning "Wrong username or password."
				# No way to get credentials, we are done here
				if [ ! -t 1 ] || [ ! -t 0 ]; then
					break
				fi
				# Reset username, since it's invalid and continue to retry
				REGANDER_USERNAME=
				continue
			fi

			# Anything but 200 or 401 is abnormal - in that case, break out and let downstream deal with it
			if [ "$DC_HTTP_STATUS" != "200" ]; then
				break
			fi

			# A 200 means authentication was successful, let's read the token and understand what just went down
			dc::jwt::read "$(jq '.token' < "$DC_HTTP_BODY" | xargs echo)"

			# TODO Actually validate the scope in full
			if [ ! "$scope" ] || [ "$DC_JWT_ACCESS" != "[]" ]; then
				dc::logger::debug "[regander] JWT scope: $scope"
				break
			fi

			# We got kicked on the scope...
			dc::logger::warning "The user $REGANDER_USERNAME was denied permission for the requested scope. Maybe the target doesn't exist, or you need a different account to access it."
			# Are we done? Move on.
			if [ ! -t 1 ] || [ ! -t 0 ]; then
				break
			fi
			# Otherwise, we are in for another try
			REGANDER_USERNAME=
		done
	}

	#####################################
	# Generic registry client helper, with authentication and http handling
	#####################################

	_regander::http(){
		local endpoint="$1"
		local method="$2"
		local payload="$3"
		shift
		shift
		shift

		local auth=
		# For first try, always use any existing token
		if [ "$DC_JWT_TOKEN" ]; then
			auth="Authorization: Bearer $DC_JWT_TOKEN"
		fi

		# Do the request
		if [ "$payload" ]; then
			_wrapper::request "$endpoint" "$method" "-" "$auth" "$@" < <(printf "%s" "$payload")
		else
			_wrapper::request "$endpoint" "$method" "" "$auth" "$@"
		fi

		# If it's a failed request, check what we have, starting with reading the header
		# TODO implement support for basic auth
		local auth=${DC_HTTP_HEADER_WWW_AUTHENTICATE}
		local service=
		local realm=
		local scope=
		local error=
		local value=

		while [ -n "$auth" ] && [ "$auth" != "$value\\"" ]; do
			key=${auth%%=*}
			key=${key#*Bearer }
			value=${auth#*=\\"}
			auth=${value#*\\",}
			value=${value%%\\"*}
			read -r "${key?}" < <(printf "%s" "$value")
		done

		dc::logger::debug "[regander] JWT service: $service" "[regander] JWT realm: $realm" "[regander] JWT scope: $scope" "[regander] JWT error: $error"

		# Did we get anything but a 401, and no scope error? We are good to go
		if [ "${DC_HTTP_STATUS}" != "401" ] && [ ! "$error" ]; then
			return
		fi

		# If we got an error at this point, it means we have a token with unsufficient scope
		if [ "$error" ]; then
			dc::logger::info "[JWT] Got an authorization error: $error. Going to try and re-authenticate with existing credentials and the specified scope."
		fi

		# Whether we got a 401 or an error, let's try against the auth server
		_regander::authenticate "$realm" "$service" "$scope" "$@"

		# If we are out of the authentication loop with anything but a 200, stop now
		if [ "$DC_HTTP_STATUS" != "200" ]; then
			return
		fi

		# Authenticate returned successfully, means we have a token to try again. Note though that the scope may still be unsufficient at this point.
		auth="Authorization: Bearer $DC_JWT_TOKEN"
		# Replay the transaction
		if [ "$payload" ]; then
			_wrapper::request "$endpoint" "$method" "-" "$auth" "$@" < <(printf "%s" "$payload")
		else
			_wrapper::request "$endpoint" "$method" "" "$auth" "$@"
		fi
	}


	_wrapper::request(){
		local ar=()
		for i in "${REGANDER_ACCEPT[@]}"; do
			ar+=("Accept: $i")
		done

		dc::http::request "$@" "${ar[@]}" "User-Agent: $REGANDER_UA"
	}

	_wrapper::request::postprocess(){
		# Acceptable status code exit now
		if [ "${DC_HTTP_STATUS:0:1}" == "2" ] || [ "${DC_HTTP_STATUS:0:1}" == "3" ]; then
			return
		fi

		# 400 errors should sport a readable error body
		#{
		#  "errors:" [{
		#          "code": <error identifier>,
		#          "message": <message describing condition>,
		#          "detail": <unstructured>
		#      },
		#      ...
		#  ]
		#}

		# Otherwise, dump the body!
		dc::http::dump::headers
		dc::http::dump::body

		# Try to produce the body if it's valid json (downstream clients may be interested in inspecting the registry error)
		jq '.' "$DC_HTTP_BODY" 2>/dev/null

		case $DC_HTTP_STATUS in
		"400")
			dc::logger::error "Something is badly borked. Check out above."
			exit "$ERROR_REGISTRY_MALFORMED"
			;;
		"401")
			# This should happen only:
			# - if we do NOT send a token to the registry, which we always end-up doing after a round-trip
			# - if the credentials sent to garant are invalid
			dc::logger::error "You can't access that resource."
			exit "$ERROR_REGISTRY_MY_NAME_IS"
			;;
		"404")
			dc::logger::error "The requested resource doesn't exist (at least for you!)."
			exit "$ERROR_REGISTRY_THIS_IS_A_MIRAGE"
			;;
		"405")
			dc::logger::error "This registry of yours does not support the requested operation. Maybe it's a cache? Or a very old dog?"
			exit "$ERROR_REGISTRY_UNKNOWN"
			;;
		"429")
			dc::logger::error "WOOOO! Slow down tiger! Registry says you are doing too many requests."
			exit "$ERROR_REGISTRY_SLOW_DOWN_TIGER"
			;;
		"")
			dc::logger::error "Network issue... Recommended: check your pooch whereabouts. Now, check these chewed-up network cables."
			exit "$ERROR_NETWORK"
			;;
		esac

		# Maybe a 5xx, then exit
		if [ "${DC_HTTP_STATUS:0:1}" == "5" ]; then
			dc::logger::error "BONKERS! A 5xx response code. You broke that poor lil' registry, you meany!"
			exit "$ERROR_REGISTRY_TITS_UP"
		fi

		# Otherwise...
		dc::logger::error "Mayday! Mayday!"
		exit "$ERROR_REGISTRY_UNKNOWN"
	}

	readonly REGANDER_DEFAULT_REGISTRY="https://registry-1.docker.io"

	# Registry errors

	## 400
	readonly ERROR_REGISTRY_MALFORMED=12
	## 401, possibly with a JWT scope error
	readonly ERROR_REGISTRY_MY_NAME_IS=13
	## 404, possibly with a JWT scope error
	readonly ERROR_REGISTRY_THIS_IS_A_MIRAGE=14
	## 405, registry doesn't support this operation
	readonly ERROR_REGISTRY_COUGH=15
	## 429: throttling
	readonly ERROR_REGISTRY_SLOW_DOWN_TIGER=16
	## 5xx
	readonly ERROR_REGISTRY_TITS_UP=17
	## Anything else that is not caught already
	readonly ERROR_REGISTRY_UNKNOWN=20

	# API
	## Doesn't return the expected http header with the API version
	readonly ERROR_SERVER_NOT_WHAT_YOU_THINK=30

	readonly ERROR_SHASUM_FAILED=31

	readonly GRAMMAR_ALPHANUM="[a-z0-9]+"
	readonly GRAMMAR_SEP="(?:[._]|__|[-]*)"
	readonly GRAMMAR_NAME="^$GRAMMAR_ALPHANUM(?:$GRAMMAR_SEP$GRAMMAR_ALPHANUM)*(?:/$GRAMMAR_ALPHANUM(?:$GRAMMAR_SEP$GRAMMAR_ALPHANUM)*)*$"
	readonly GRAMMAR_TAG="^[a-z0-9_][a-z0-9_.-]{0,127}$"
	readonly GRAMMAR_DIGEST="^[a-z][a-z0-9]*(?:[-_+.][a-z][a-z0-9]*)*:[a-f0-9]{32,}$"
	readonly GRAMMAR_DIGEST_SHA256="^sha256:[a-f0-9]{64}$"
	readonly GRAMMAR_TAG_DIGEST="^(?:[a-z0-9_][a-z0-9_.-]{0,127}|sha256:[a-f0-9]{64})$"

	# v1
	readonly MIME_V1_MANIFEST="application/vnd.docker.distribution.manifest.v1+json"
	readonly MIME_V1_MANIFEST_JSON="application/json"
	readonly MIME_V1_MANIFEST_SIGNED="application/vnd.docker.distribution.manifest.v1+prettyjws"

	# v2
	readonly MIME_V2_MANIFEST="application/vnd.docker.distribution.manifest.v2+json"
	readonly MIME_V2_LIST="application/vnd.docker.distribution.manifest.list.v2+json"

	# Subtypes
	readonly MIME_V2_CONFIG="application/vnd.docker.container.image.v1+json"
	readonly MIME_V2_LAYER="application/vnd.docker.image.rootfs.diff.tar.gzip"
	readonly MIME_V2_FOREIGN="application/vnd.docker.image.rootfs.foreign.diff.tar.gzip"

	# Alternative config objects
	readonly MIME_V2_CONFIG_PLUGIN="application/vnd.docker.plugin.v1+json"
	readonly MIME_V2_CONFIG_X_APP="x-application/vnd.docker.app-definition.v1+json"
	readonly MIME_V2_CONFIG_X_APP_TPL="x-application/vnd.docker.app-template.v1+json"

	# OCI
	readonly MIME_OCI_MANIFEST="application/vnd.oci.image.manifest.v1+json"
	readonly MIME_OCI_LIST="application/vnd.oci.image.index.v1+json"

	# Subtypes
	readonly MIME_OCI_CONFIG="application/vnd.oci.image.config.v1+json"
	readonly MIME_OCI_LAYER="application/vnd.oci.image.layer.v1.tar"
	readonly MIME_OCI_GZLAYER="application/vnd.oci.image.layer.v1.tar+gzip"
	readonly MIME_OCI_FOREIGN="application/vnd.oci.image.layer.nondistributable.v1.tar"
	readonly MIME_OCI_GZFOREIGN="application/vnd.oci.image.layer.nondistributable.v1.tar+gzip"

	#################################
	# re::shasum::compute FILE EXPECTED
	#################################
	#
	# A shasum helper that computes a docker digest from a local file
	# Sets a "computed_digest" variable with the compute digest
	# Also sets a verified variable to either the null string or "verified" if the computed digest matches the second (optional) argument
	regander::shasum::verify(){
		dc::require shasum
		local file="$1"
		local expected="$2"
		digest=$(shasum -a 256 "$file" 2>/dev/null)
		digest="sha256:${digest%% *}"
		if [ "$digest" != "$expected" ]; then
			dc::logger::error "Verification failed for object $file (expected: $expected - was: $digest)"
			dc::logger::debug "File was $file"
			exit "$ERROR_SHASUM_FAILED"
		fi
	}

	regander::shasum::compute(){
		dc::require shasum
		local file="$1"
		digest=$(shasum -a 256 "$file" 2>/dev/null)
		printf "%s" "sha256:${digest%% *}"
	}

	_help::section(){
		tput setaf 1
		printf "%s\\n" "-------------------------------------------"
		printf "%s\\n" "$@"
		printf "%s\\n" "-------------------------------------------"
		tput op
		printf "\\n"
	}

	_help::item(){
		tput setaf 2
		printf "%s\\n" ">>>>> $* <<<<<"
		tput op
		printf "\\n"
	}

	_help::example(){
		tput setaf 3
		printf "%s\\n" "$*"
		tput op
		printf "\\n"
	}

	_help::exampleindent(){
		tput setaf 3
		printf "\\t%s\\n" "$*"
		tput op
		printf "\\n"
	}

	# Need help?
	dc::commander::help(){
		local name="$1"
		local version="$2"
		local license=$3
		#local shortdesc=$4
		#local shortusage=$5

		printf "%s\\n" "$name, version $version, released under $license"
		printf "\\t%s\\n" "> a fancy piece of shcript implementing a standalone Docker registry protocol client"
		printf "\\n"
		printf "%s\\n" "Usage:"
		printf "\\t%s\\n" "$name [options] endpoint METHOD [object] [reference] [origin-object]"

		_help::section "Endpoints"

		_help::item "1. Version (GET)"

		_help::example "$name [--registry=foo] [-s] version GET"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Get the Hub protocol version, interactively asking for credentials"
		_help::exampleindent "$name -s version GET"
		printf "\\t%s\\n" "b. Get the protocol version from registry-1.docker.io using anonymous and pipe it to jq"
		_help::exampleindent "$name -s --registry=https://registry-1.docker.io version GET | jq"

		_help::item "2. Tag list (GET)"

		_help::example "$name [--registry=foo] [-s] tags GET imagename"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Get all tags for the official nginx image"
		_help::exampleindent "$name -s tags GET library/nginx"
		printf "\\t%s\\n" "b. Same, but filter out only the tags containing 'alpine' in their name"
		_help::exampleindent "$name -s tags GET library/nginx | jq '.tags | map(select(. | contains(\"alpine\")))'"

		_help::item "3a. Manifest (HEAD)"

		_help::example "$name [--registry=foo] [--downgrade] [-s] manifest HEAD imagename [reference]"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Get all info for nginx latest"
		_help::exampleindent "$name -s manifest HEAD library/nginx"
		printf "\\t%s\\n" "b. Get the digest for the 'alpine' tag of image 'nginx':"
		_help::exampleindent "$name -s manifest HEAD library/nginx alpine | jq .digest"

		_help::item "3b. Manifest (GET)"

		_help::example "$name [--registry=foo] [--downgrade] [-s] manifest GET imagename [reference]"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Get the manifest for the latest tag of image nginx:"
		_help::exampleindent "$name -s manifest GET library/nginx"
		printf "\\t%s\\n" "b. Get the v1 manifest for the latest tag of image nginx, and extract the layers array:"
		_help::exampleindent "$name -s --registry=https://registry-1.docker.io --downgrade --disable-verification manifest GET library/nginx latest | jq .fsLayers"

		_help::item "3c. Manifest (DELETE)"

		_help::example "$name [--registry=foo] [-s] manifest DELETE imagename reference"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Delete a tag (note: Hub doesn't support this apparently)"
		_help::exampleindent "$name -s manifest DELETE you/yourimage sometag"
		printf "\\t%s\\n" "b. Delete by digest (note: Hub doesn't support this apparently)"
		_help::exampleindent "$name -s manifest DELETE you/yourimage sha256:foobar"

		_help::item "3d. Manifest (PUT)"

		_help::example "$name [--registry=foo] [-s] manifest PUT imagename reference < file"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Put a manifest from a file"
		_help::exampleindent "REGISTRY_USERNAME=you REGISTRY_PASSWORD=yourpass $name -s manifest PUT you/yourimage sometag < localmanifest.json"
		printf "\\t%s\\n" "b. From stdin"
		_help::exampleindent "printf \\"%s\\" \\"Manifest content\\" | REGISTRY_USERNAME=you REGISTRY_PASSWORD=yourpass $name -s manifest PUT you/yourimage sometag"
		printf "\\t%s\\n" "c. Black magic! On the fly copy from image A to B (note: this assumes all blobs are mounted already in the destination)."
		_help::exampleindent "$name -s manifest GET library/nginx latest | REGISTRY_USERNAME=you REGISTRY_PASSWORD=yourpassword $name -s manifest PUT you/yourimage sometag"
		printf "\\t%s\\n" "d. Same as c, for v1 (note: this assumes all blobs are mounted already in the destination) (note: Hub doesn't support this anymore. This is untested)."
		_help::exampleindent "$name -s --downgrade --disable-verification manifest GET library/nginx latest | REGISTRY_USERNAME=you REGISTRY_PASSWORD=yourpassword $name -s --downgrade manifest PUT you/yourimage sometag"

		_help::item "4a. Blob (HEAD)"

		_help::example "$name [--registry=foo] [-s] blob HEAD imagename reference"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Get the final location after redirect for a blob:"
		_help::exampleindent "$name -s blob HEAD library/nginx sha256:911c6d0c7995e5d9763c1864d54fb6deccda04a55d7955123a8e22dd9d44c497 | jq .location"

		_help::item "4b. Blob (GET)"

		_help::example "$name [--registry=foo] [-s] blob GET imagename reference"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Download a blob to a file"
		_help::exampleindent "$name -s blob GET library/nginx sha256:911c6d0c7995e5d9763c1864d54fb6deccda04a55d7955123a8e22dd9d44c497 > layer.tgz"

		_help::item "4c. Blob (MOUNT)"

		_help::example "$name [--registry=foo] [-s] blob MOUNT imagename reference origin"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Mount a layer from nginx into image yourimage"
		_help::exampleindent "$name -s blob MOUNT you/yourimage sha256:911c6d0c7995e5d9763c1864d54fb6deccda04a55d7955123a8e22dd9d44c497 library/nginx"

		_help::item "4d. Blob (DELETE)"

		_help::example "$name [--registry=foo] [-s] blob DELETE imagename reference"
		printf "%s\\n" "Examples:"
		printf "\\t%s\\n" "a. Unmount a layer from yourimage (note: Hub doesn't support this apparently)."
		_help::exampleindent "$name -s blob DELETE you/yourimage sha256:911c6d0c7995e5d9763c1864d54fb6deccda04a55d7955123a8e22dd9d44c497"

		_help::section "Options details"

		printf "%s\\n" " > --registry=foo     Points to a specific registry address. If ommitted, will default to Docker Hub."
		printf "%s\\n" " > -s, --silent       Will not log out anything to stderr."
		printf "%s\\n" " > --help             Will display all that jazz..."

		_help::section "DANGEROUS *DANGER* options"

		printf "%s\\n" " > --downgrade            Downgrade operations from v2 to v1 manifest schema. Only has an effect when using the manifest endpoint, ignored otherwise."
		printf "%s\\n" " > --insecure             Silently ignore TLS errors."
		printf "%s\\n" " > --disable-verification Do NOT verify that payloads match their Digest, as advertised by the registry. This is DANGEROUS, and only useful for debugging, or to manipulate schema 1 on-the-fly conversions."

		_help::section "Logging and logging options"

		printf "%s\\n" "By default, all logging is sent to stderr. Options:"
		printf "\\t%s\\n" "a. Disable all logging"
		_help::exampleindent "$name -s version GET"
		printf "\\t%s\\n" "b. Enable debug logging (verbose!)"
		_help::exampleindent "REGANDER_LOG_LEVEL=true $name version GET"
		printf "\\t%s\\n" "c. Also enable authentication debugging info (this *will* LEAK authentication tokens to stderr!)"
		_help::exampleindent "REGANDER_LOG_LEVEL=true REGANDER_LOG_AUTH=true $name version GET"
		printf "\\t%s\\n" "d. Redirect all logging to /dev/null (essentially has the same result as using -s)"
		_help::exampleindent "$name version GET 2>/dev/null"
		printf "\\t%s\\n" "e. Log to a file and redirect the result of the command to a file"
		_help::exampleindent "$name version GET 2>logs.txt >version.json"

		_help::section "Non interactive authentication"

		printf "%s\\n" "You can use the REGISTRY_USERNAME and REGISTRY_PASSWORD environment variables if you want to use this non-interactively (typically if you are piping the output to something else)."
	}


	readonly CLI_VERSION="0.0.1"
	readonly CLI_LICENSE="MIT License"
	readonly CLI_DESC="docker registry shell script client"
	readonly CLI_USAGE="[-s] [--insecure] [--downgrade] [--disable-verification] [--registry=https://registry-1.docker.io] endpoint METHOD [name] [reference] [source]"

	# Init
	dc::commander::initialize "" ""
	# Validate arguments
	dc::commander::declare::flag downgrade "^$" "optional" ""
	dc::commander::declare::flag disable-verification "^$" "optional" ""
	dc::commander::declare::flag registry "^http(s)?://.+$" "optional" ""
	dc::commander::declare::arg 1 "^blob|manifest|tags|catalog|version$" "" "endpoint" "what to hit"
	dc::commander::declare::arg 2 "^HEAD|GET|PUT|DELETE|MOUNT|POST$" "" "method" "method to use"
	dc::commander::declare::arg 3 "$GRAMMAR_NAME" "optional" "name" "image name, like: library/nginx"
	dc::commander::declare::arg 4 "$GRAMMAR_TAG_DIGEST" "optional" "reference" "tag name or digest"
	dc::commander::declare::arg 5 "$GRAMMAR_NAME" "optional" "source" "when blob mounting, origin image name"
	# Boot
	dc::commander::boot

	# Requirements
	dc::require jq

	# Further argument validation
	if [ ${#3} -ge 256 ]; then
		dc::logger::error "Image name $3 is too long"
		exit "$ERROR_ARGUMENT_INVALID"
	fi

	if [ ${#5} -ge 256 ]; then
		dc::logger::error "Source image name $5 is too long"
		exit "$ERROR_ARGUMENT_INVALID"
	fi


	# Build the registry url, possibly honoring the --registry variable
	readonly REGANDER_REGISTRY="${DC_ARGV_REGISTRY:-${REGANDER_DEFAULT_REGISTRY}}/v2"

	# Build the UA string
	# -${DC_BUILD_DATE} <- too much noise
	readonly REGANDER_UA="${CLI_NAME:-${DC_CLI_NAME}}/${CLI_VERSION:-${DC_CLI_VERSION}} dubocore/${DC_VERSION}-${DC_REVISION} (bash ${DC_DEPENDENCIES_V_BASH}; jq ${DC_DEPENDENCIES_V_JQ}; $(uname -mrs))"

	# Map credentials to the internal variable
	export REGANDER_USERNAME="$REGISTRY_USERNAME"
	export REGANDER_PASSWORD="$REGISTRY_PASSWORD"

	# If --downgrade is passed, change the accept header
	if [ "${DC_ARGE_DOWNGRADE}" ]; then
		REGANDER_ACCEPT=(
			"$MIME_V1_MANIFEST"
			"$MIME_V1_MANIFEST_JSON"
			"$MIME_V1_MANIFEST_SIGNED"
		)
	else
		REGANDER_ACCEPT=(
			"$MIME_V2_MANIFEST"
			"$MIME_V2_LIST"
			"$MIME_OCI_MANIFEST"
			"$MIME_OCI_LIST"
		)
	fi

	export REGANDER_ACCEPT

	export REGANDER_NO_VERIFY=${DC_ARGE_DISABLE_VERIFICATION}

	# Call the corresponding method
	if ! regander::"$(echo "$1" | tr '[:upper:]' '[:lower:]')"::"$(echo "$2" | tr '[:lower:]' '[:upper:]')" "$3" "$4" "$5"; then
		dc::logger::error "The requested endpoint ($1) and method ($2) doesn't exist in the registry specification or is not supported by regander."
		exit "$ERROR_ARGUMENT_INVALID"
	fi
	"""
}
