Volume:: Block & {
	blocksettings = settings

	settings: {
		endpoint: Docker.Endpoint
		network: Docker.Network

		nickname: string | * "volume"
		hostname: string | * "nodehostname"
		log: bool | *false
		dns: [...string] | *[]

		station: string | * "Volume Super Croquette"

		device: string | * "PCM"
		card: int | *0

		command?: [...string]
	}

	block: image: Docker.Image & {
		settings: {
			endpoint: blocksettings.endpoint

			name: string | * "dubodubonduponey/volume"
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
			command?: blocksettings.command
		}
	}
}
