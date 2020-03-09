top_level_settings = settings

// First block is to get a valid ssh connection to the host - other blocks should depend on this - if this fails, we should bail out here
block: daemon: Docker.Daemon & {
	settings: {
		debug: false

		endpoint: top_level_settings.endpoint
	}
}

block: network: Docker.Network & {
	settings: {
		debug: false

		controller: block.daemon

		name: "hackvlan"
		driver: "macvlan"
		subnet: "192.168.1.0/24"
		gateway: "192.168.1.1"
		ip_range: "192.168.1.150/28"
		parent: "eth0"
		ipvlan_mode: "l2"
	}
}

// Now, ready to hook-that shit in
block: production: Airport & {
	settings: {
		debug: false

		controller: block.daemon
		network: block.network

		nickname: "airport"
		hostname: "foo"
		log: true
		dns: []
		station: "(Airport controller)"

		command: [
			"--",
			"-d",
			"hw:1",
		]


//		hostname: "nucomedon.local"
//		log: true
//		dns: []
//		station: "Super Croquette de Munster"
//		hw_index: 1
//		card_name: "PCM"
//		mixer_name: "Mojo"
//		volume: 100
	}
}
