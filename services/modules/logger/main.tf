resource "docker_container" "logger" {
  provider      = docker
  name          = local.host
  image         = docker_image.logger.latest
  hostname      = "${local.host}.${var.hostname}"

  network_mode  = var.network

  labels        = {
    "co.elastic.logs/enabled": false,
  }

  env           = [
    "ELASTICSEARCH_HOSTS=[\"${var.elastic}\"]",
    "KIBANA_HOST=${var.kibana}",
    "HEALTHCHECK_URL=http://${var.elastic}",
    "MODULES=coredns system",
  ]

  mounts {
    target      = "/var/lib/docker/containers"
    source      = "/var/lib/docker/containers"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/run/docker.sock"
    source      = "/var/run/docker.sock"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/syslog"
    source      = "/var/log/syslog"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/auth.log"
    source      = "/var/log/auth.log"
    read_only   = true
    type        = "bind"
  }

  dns           = var.dns

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
  user          = "root"
}
