resource "docker_container" "dns" {
  provider      = docker
  name          = local.host
  image         = docker_image.dns.latest
  hostname      = "${local.host}.${var.hostname}"

  network_mode  = var.network

  env = [
    "UPSTREAM_SERVER_1=${local.address_1}",
    "UPSTREAM_SERVER_2=${local.address_2}",
    "UPSTREAM_NAME=${var.upstream_name}",
    "DNS_PORT=53",
  ]

  labels = {
    "co.elastic.logs/enabled": true,
    "co.elastic.logs/module": "coredns",
    "co.elastic.logs/fileset": "log",
  }

  # Regular DNS service
  # ports {
  #   internal    = 53
  #  external    = 53
  #   protocol    = "udp"
  # }

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop  = ["ALL"]
    add   = ["NET_BIND_SERVICE"]
  }
  user          = "root"
}
