nucomedonStation: blocklayer.Block & {
	top_level_settings = settings

	settings: {
		privatekey: string | * ""
		passphrase: string | *""
		host: "dmp@192.168.1.8:22"
	}

	// First block is to get a valid ssh connection to the host - other blocks depend on this - if this fails, bail out here
	block: daemon: Docker.Daemon & {
		settings: {
			privatekey: top_level_settings.key
			passphrase: top_level_settings.passphrase
			host: top_level_settings.host
		}
	}

	// Then get a macvlan network hooked-in
	block: network: Docker.Network & {
		settings: {
			daemon: block.daemon

			name: "hackvlan"

			driver: "macvlan"

			subnet: "192.168.1.0/24"
			gateway: "192.168.1.1"
			ip_range: "192.168.1.48/28"
			parent: "eno1"
			ipvlan_mode: "l2"
		}
	}

	// Now, ready to hook-that shit in
	block: production: Audio & {
		settings: {
			daemon: block.daemon
			network: block.network

			hostname: "nucomedon.local"
			log: true
			dns: ["192.168.1.8"]
			station: "Super Croquette de Munster"
			hw_index: 1
			card_name: "PCM"
			mixer_name: "Mojo"
			volume: 100
		}
	}


	block: [pr=int]: Audio & {
		settings: {
			daemon: block.daemon
			network: block.network

			hostname: "nucomedon-\(pr).local"
			log: true
			dns: ["192.168.1.8"]
			station: "Super Croquette de Poule Recuite"
			hw_index: 1
			card_name: "PCM"
			mixer_name: "Mojo"
			volume: 100
		}

		block: airport: block: image: settings: tag: "foofoo\(pr)something"
		block: raat: block: image: settings: tag: "foofoo\(pr)something"
		block: spot: block: image: settings: tag: "foofoo\(pr)something"
		block: volume: block: image: settings: tag: "foofoo\(pr)something"
	}
}

