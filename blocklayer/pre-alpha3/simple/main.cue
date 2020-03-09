top_level_settings = settings

// First block is to get a valid ssh connection to the host - other blocks should depend on this - if this fails, we should bail out here
block: daemon: Docker.Controller & {
	settings: {
		endpoint: top_level_settings.endpoint
		debug: true
	}
}

