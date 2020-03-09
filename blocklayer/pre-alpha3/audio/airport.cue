Airport:: Docker.Block & {
	blocksettings = settings

	settings: {
		controller: Docker.privateController
		network: Docker.Network

		nickname: string | * "airport"
		hostname: string | * "nodehostname"
		log: bool | *false
		dns: [...string] | *[]

		station: string | * "Airport Super Croquette"

		debug: bool | *false

		command?: [...string]

		action: """
		echo lol"""
	}

//	{
//		settings: debug: true
//		settings: command: [...string] | *[
//			"-vv",
//			"--statistics",
//			"--",
//			"-d",
//			"hw:\(settings.hw_index)",
//		]
//	} | {
//		settings: debug: false
//		settings: command: [...string] | *[
//			"--",
//			"-d",
//			"hw:\(settings.hw_index)",
//		]
//	}


	block: image: Docker.Image & {
		settings: {
			controller: blocksettings.controller

			name: string | * "dubodubonduponey/shairport-sync"
			tag: string | * "v1"
		}
	}

	block: container: Docker.Container & {
		settings: {
			controller: blocksettings.controller
			image: block.image
			network: blocksettings.network

			nickname: blocksettings.nickname
			hostname: blocksettings.hostname
			log: blocksettings.log
			dns: blocksettings.dns
			station: blocksettings.station
			command: blocksettings.command

			card: 1

			config: {
				hostname: blocksettings.hostname
				log: blocksettings.log
				dns: blocksettings.dns
				station: blocksettings.station

				command: blocksettings.command

				env: [
					"NAME=\(blocksettings.station)",
				]
			}
//			if settings.debug
		}
	}
}
