package top

import (
//	"strings"

	"loop-dev.com/docker"
)

foo: docker.Controller & {
	settings: {
		endpoint: private_settings.endpoint
		debug: true
		action: "echo lol"
	}
}

// foo: Daemon & {}
