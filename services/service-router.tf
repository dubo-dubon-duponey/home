resource "docker_container" "system-router" {
  provider      = docker.nucomedon
  name          = "router"
  image         = docker_image.router.latest

  network_mode  = docker_network.nuc_bridge.name

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
  # DNS config and dependencies
  # https://github.com/moby/moby/issues/11998#issuecomment-108978708
  # XXX goddamn it @Madhu!
  /*
  depends_on    = [
    docker_container.dns_nuc
  ]
  dns           = [docker_network.nuc_bridge]
  */

  # Secure it
  # restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
}
