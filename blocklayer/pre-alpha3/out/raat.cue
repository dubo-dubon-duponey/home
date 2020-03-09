Raat:: Block & {
	blocksettings = settings

	settings: {
		endpoint: Docker.Endpoint
		network: Docker.Network

		nickname: string | * "raat"
		hostname: string | * "nodehostname"
		log: bool | *false
		dns: [...string] | *[]
	}

	block: image: Docker.Image & {
		settings: {
			endpoint: blocksettings.endpoint

			name: string | * "dubodubonduponey/raat"
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
		}
	}
}
