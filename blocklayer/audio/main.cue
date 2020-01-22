top_level_settings = settings

settings: {
	endpoint: Docker.Endpoint & {
		key: string | * """
-----BEGIN OPENSSH PRIVATE KEY-----
xxxxxxxxx
REDACTED
xxxxxxxxx
-----END OPENSSH PRIVATE KEY-----"""
		passphrase: string | *"XXXREDACTEDXXX"
		host: "192.168.1.8"
		user: "dmp"
		port: 22
	}
}

// First block is to get a valid ssh connection to the host - other blocks should depend on this - if this fails, we should bail out here
block: daemon: Docker.Daemon & {
	settings: {
		endpoint: top_level_settings.endpoint
		debug: false
	}
}

// Then get a macvlan network hooked-in
block: network: Docker.Network & {
	settings: {
		endpoint: top_level_settings.endpoint
		debug: false

		name: "hackvlan"
		driver: "macvlan"
		subnet: "192.168.1.0/24"
		gateway: "192.168.1.1"
		ip_range: "192.168.1.150/28"
		parent: "eno1"
		ipvlan_mode: "l2"
	}
}


block: image: Docker.Image & {
	settings: {
		endpoint: top_level_settings.endpoint

		name: string | * "dubodubonduponey/shairport-sync"
		tag: string | * "v1"
	}
}

block: container: Docker.Container & {
	settings: {
		endpoint: top_level_settings.endpoint
		image: block.image
		network: block.network
		nickname: "blocklayer-ftw"

		card: 1

		config: {
			hostname: "blocklayer.nucomedon.local"
			log: true
			dns: ["192.168.1.8"]
			station: "AirplaySiJaiUnGrosCoupDeCue"

			command: [
				"--",
				"-d",
				"hw:\(settings.card)",
			]

			env: [
				"NAME=\(station)",
				"FOO=bar",
			]
		}
	}
}

