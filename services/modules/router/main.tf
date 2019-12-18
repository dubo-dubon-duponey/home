resource "docker_container" "container" {
  provider      = docker
  image         = docker_image.image.latest

  name          = local.container_name
  hostname      = local.container_hostname
  network_mode  = local.container_network
  dns           = local.container_dns
  user          = local.container_user

  restart       = "always"
  read_only     = true

  capabilities {
    drop  = ["ALL"]
    add   = local.container_capabilities
  }

  labels        = {
    "co.elastic.logs/enabled": local.log,
  }

  volumes {
    volume_name = docker_volume.certs.name
    container_path = "/certs"
  }

  /*
  volumes {
    volume_name = docker_volume.tmp.name
    container_path = "/tmp"
  }
  */

  mounts {
    target      = "/config/sites.d"
    source      = "/home/container/config/router/sites.d"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/config/static"
    source      = "/home/container/config/router/static"
    read_only   = true
    type        = "bind"
  }

  env = [
    "DOMAIN=https://${local.domain}",
    "STAGING=${local.staging}",
    "EMAIL=${local.email}",
    "USERNAME=${local.user}",
    "PASSWORD=${local.password}",
    "MONITOR=${local.kibana}",
  ]

  # Regular HTTPS service
  ports {
    internal    = 1443
    external    = 443
    protocol    = "tcp"
  }

  # HTTP endpoint
  ports {
    internal    = 1080
    external    = 80
    protocol    = "tcp"
  }

  # Prometheus
  ports {
    internal    = 9180
    external    = 9180
    protocol    = "tcp"
  }
}
