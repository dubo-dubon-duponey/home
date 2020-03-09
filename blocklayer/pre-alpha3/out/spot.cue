Spot:: Block & {
	blocksettings = settings

	settings: {
		endpoint: Docker.Endpoint
		network: Docker.Network

		nickname: string | * "volume"
		hostname: string | * "nodehostname"
		log: bool | *false
		dns: [...string] | *[]

		station: string | * "Spot Super Croquette"

		card_name: string | *"default"
		mixer_name: string | *"PCM"
		hw_index: int | *0
		volume: int | *75

		command: [...string] | *[
			"--device",
			"default:CARD=\(settings.card_name)",
			"--mixer-name",
			settings.mixer_name,
			"--mixer-card",
			"hw:\(settings.hw_index)",
			"--initial-volume",
			settings.volume,
			"--enable-volume-normalisation",
		]
	}

	block: image: Docker.Image & {
		settings: {
			endpoint: blocksettings.endpoint

			name: string | * "dubodubonduponey/librespot"
			tag: string | * "v1"
		}
	}

	block: container: Docker.Container & {
		settings: {
			endpoint: blocksettings.endpoint
			network: blocksettings.network
			image: block.image

			nickname: blocksettings.nickname
			hostname: blocksettings.hostname
			log: blocksettings.log
			dns: blocksettings.dns
			station: blocksettings.station
			command: blocksettings.command
		}
	}

}
