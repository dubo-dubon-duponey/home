######################################################
# DNS
######################################################

resource "docker_container" "dns" {
  provider      = docker
  name          = local.host_dns
  image         = docker_image.dns.latest
  hostname      = "${local.host_dns}.${var.hostname}"

  network_mode  = var.network

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

######################################################
# Logger
######################################################
resource "docker_container" "logger" {
  provider      = docker
  name          = local.host_logger
  image         = docker_image.logger.latest
  hostname      = "${local.host_logger}.${var.hostname}"

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

  # DNS config and dependencies
  # XXX depends_on necessary?
  depends_on    = [
    docker_container.dns
  ]
  dns           = [docker_container.dns.ip_address]

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
  user          = "root"
}
