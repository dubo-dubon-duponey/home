Audio:: Block & {
	top_level_settings = settings

	settings: {
		endpoint: Docker.Endpoint
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
				endpoint: top_level_settings.endpoint
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

		spot: Spot & {
			settings: {
				endpoint: top_level_settings.endpoint
				network: top_level_settings.network

				nickname: "spot"
				hostname: top_level_settings.hostname
				log: top_level_settings.log
				dns: top_level_settings.dns
				station: "\(top_level_settings.station) (Spotify controller)"
				command: [
					"--device",
					"default:CARD=\(top_level_settings.card_name)",
					"--mixer-name",
					top_level_settings.mixer_name,
					"--mixer-card",
					"hw:\(top_level_settings.hw_index)",
					"--initial-volume",
					"\(top_level_settings.volume)",
					"--enable-volume-normalisation",
				]
			}
		}

		raat: Raat & {
			settings: {
				endpoint: top_level_settings.endpoint
				network: top_level_settings.network

				nickname: "raat"
				hostname: top_level_settings.hostname
				log: top_level_settings.log
				dns: top_level_settings.dns
			}
		}

		volume: Volume & {
			settings: {
				endpoint: top_level_settings.endpoint
				network: top_level_settings.network

				nickname: "volume"
				hostname: top_level_settings.hostname
				log: top_level_settings.log
				dns: top_level_settings.dns
				station: "\(top_level_settings.station) (Volume control)"
				device: top_level_settings.mixer_name
				card: top_level_settings.hw_index
			}
		}
	}
}
