package top

import (
//	"strings"

	"loop-dev.com/docker"
)

// foo: docker.Controller & {
//}

foo: docker.Daemon & {
	settings:: {
		endpoint: private_settings.endpoint
//		debug: true
	}
}
