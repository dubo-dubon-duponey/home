package bl

import (
	"strings"
)

Secret :: {
	value: _
}

Dockerfile :: {
	package: [pkg=string]: true
	package: bash:         true // always install bash
	package: jq:           true // always install jq
	extraCommand: [...string]

	installPackages = strings.Join([
		"run apk add -U --no-cache \(pkg)"
		for pkg, _ in package
	], "\n")
	runExtraCommands = strings.Join([
		"run \(cmd)"
		for cmd in extraCommand
	], "\n")

	alpineVersion: "latest"
	alpineDigest:  "sha256:ab00606a42621fb68f2ed6ad3c88be54397f981a7b70a79db3d1172b11c4367d"

	text: """
		from alpine:\(alpineVersion)@\(alpineDigest)
		\(installPackages)
		\(runExtraCommands)
		"""
}

Directory :: {
	{
		// Directory from another directory (e.g. subdirectory)
		from: Directory
	} | {
		// Reference to remote directory
		ref: string
	} | {
		// Use a local directory
		local: string
	}
	path: string | *"/"
}

Cache :: {
	key:  string | *""
}

RunPolicy :: *"onChange" | "always"

Status :: "complete" | "error"

BashScript :: {
	$bl: "bl.BashScript"

	code: string

	os: {
		package: [string]: true
		extraCommand: [...string]
	}
	dockerfile: (Dockerfile & {
		package:      os.package
		extraCommand: os.extraCommand
	}).text

	runPolicy: RunPolicy
	environment: [string]: string
	workdir: string | *"/"

	Input :: Directory | string | bytes | Cache
	input: [path=string]: Input

	Output :: Directory | string | bytes
	output: [path=string]: Output

	status: Status
}
