Audio:: Docker.Block & {
	top_level_settings = settings

	settings: {
		controller: Docker.Block
		network: Docker.Network

		hostname: string
		log: bool
		dns: [...string]
		station: string
		hw_index: int
		card_name: string
		mixer_name: string
		volume: int
	}

	block: {
		airport: Airport & {
			settings: {
				controller: top_level_settings.controller
				network: top_level_settings.network

				nickname: "airport"
				hostname: top_level_settings.hostname
				log: top_level_settings.log
				dns: top_level_settings.dns
				station: "\(top_level_settings.station) (Airport controller)"

				command: [
					"--",
					"-d",
					"hw:\(top_level_settings.hw_index)",
				]
			}
		}
 	}
}



