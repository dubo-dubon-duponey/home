resource "docker_container" "dns_nuc" {
  provider      = docker.nucomedon
  name          = "dns"
  image         = docker_image.dns_nuc.latest
  hostname      = "dns.nucomedon.container"

  network_mode  = docker_network.nuc_bridge.name

  env = [
    "UPSTREAM_SERVER_1=${local.dns_upstream_address_1}",
    "UPSTREAM_SERVER_2=${local.dns_upstream_address_2}",
    "UPSTREAM_NAME=${var.dns_upstream_name}",
    "DNS_PORT=53",
  ]

  labels = {
    "co.elastic.logs/enabled": true,
    "co.elastic.logs/module": "coredns",
    "co.elastic.logs/fileset": "log",
  }

  # Regular DNS service
  ports {
    internal    = 53
    external    = 53
    protocol    = "udp"
  }

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop  = ["ALL"]
    add   = ["NET_BIND_SERVICE"]
  }
  user          = "root"
}

resource "docker_container" "dns_dac" {
  provider      = docker.dacodac
  name          = "dns"
  image         = docker_image.dns_dac.latest
  hostname      = "dns.dacodac.container"

  network_mode  = docker_network.dac_bridge.name

  env = [
    "UPSTREAM_SERVER_1=${local.dns_upstream_address_1}",
    "UPSTREAM_SERVER_2=${local.dns_upstream_address_2}",
    "UPSTREAM_NAME=${var.dns_upstream_name}",
    "DNS_PORT=53",
  ]

  labels = {
    "co.elastic.logs/enabled": true,
    "co.elastic.logs/module": "coredns",
    "co.elastic.logs/fileset": "log",
  }

  # Regular DNS service
  ports {
    internal    = 53
    external    = 53
    protocol    = "udp"
  }

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop  = ["ALL"]
    add   = ["NET_BIND_SERVICE"]
  }
  user          = "root"
}

resource "docker_container" "dns_nig" {
  provider      = docker.nightingale
  name          = "dns"
  image         = docker_image.dns_nig.latest
  hostname      = "dns.nightingale.container"

  network_mode  = docker_network.nig_bridge.name

  env = [
    "UPSTREAM_SERVER_1=${local.dns_upstream_address_1}",
    "UPSTREAM_SERVER_2=${local.dns_upstream_address_2}",
    "UPSTREAM_NAME=${var.dns_upstream_name}",
    "DNS_PORT=53",
  ]

  labels = {
    "co.elastic.logs/enabled": true,
    "co.elastic.logs/module": "coredns",
    "co.elastic.logs/fileset": "log",
  }

  # Regular DNS service
  #ports {
  #  internal    = 1053
  #  external    = 53
  #  protocol    = "udp"
  #}

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop  = ["ALL"]
    add   = ["NET_BIND_SERVICE"]
  }
  user          = "root"
}
