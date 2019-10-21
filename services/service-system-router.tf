resource "docker_container" "system_router" {
  provider      = docker.nucomedon
  name          = "router"
  image         = docker_image.router.latest
  hostname      = "router.nucomedon.container"

  network_mode  = docker_network.nuc_bridge.name

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  env = [
    "DOMAIN=https://router.farcloser.world",
    "STAGING=",
    "EMAIL=${var.email}",
  ]

  # Regular HTTPS service
  ports {
    internal    = 1443
    external    = 443
    protocol    = "tcp"
  }

  ports {
    internal    = 1080
    external    = 80
    protocol    = "tcp"
  }

  ports {
    internal    = 9180
    external    = 9180
    protocol    = "tcp"
  }

  volumes {
    volume_name = docker_volume.router_certs_nuc.name
    container_path = "/certs"
  }

  /*
  mounts {
    target      = "/config"
    source      = "${var.docker_config}/config/router"
    read_only   = true
    type        = "bind"
  }
  */

  depends_on    = [
    docker_container.dns_nuc
  ]
  dns           = [docker_container.dns_nuc.ip_address]

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
}
