resource "docker_image" "dns" {
  provider      = docker
  name          = data.docker_registry_image.system-dns.name
  pull_triggers = [data.docker_registry_image.system-dns.sha256_digest]

  # Creating config directory beforehand if not there yet
  provisioner "local-exec" {
    command     = "mkdir -p \"${var.docker_config}/dns\""
  }
}

resource "docker_container" "dns" {
  provider      = docker
  name          = "dns"
  image         = docker_image.dns.latest

  restart       = "always"

  network_mode  = "bridge"

  capabilities {
    drop = ["ALL"]
  }

  env           = [
    "UPSTREAM_NAME=${var.dns_upstream_name}",
    "UPSTREAM_SERVERS=${var.dns_upstream_addresses}",
    "OVERWRITE_CONFIG=true",
  ]

  # Regular DNS service
  ports {
    internal    = 1053
    external    = 53
    protocol    = "udp"
  }

  # DNS over TLS
  ports {
    internal    = 1853
    external    = 853
  }

  mounts {
    target      = "/config"
    source      = "${var.docker_config}/dns"
    read_only   = false
    type        = "bind"
  }
}
