# Local indirection
locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = (var.user == "root" ? var.port : local.defaults.port)

  // if at least one of the networks is a bridge, and if expose is true
  container_expose  = var.expose ? {
    (var.port): local.service_port,
  } : {}

  env           = [
    "DOMAIN=",
    "EMAIL=",
    "UPSTREAM_SERVER_1=${local.dns_upstream_1}",
    "UPSTREAM_SERVER_2=${local.dns_upstream_2}",
    "UPSTREAM_NAME=${local.dns_upstream_name}",
    "STAGING=",
    "DNS_PORT=${local.service_port}",
    "TLS_PORT=1853",
    "HTTPS_PORT=1443",
    "GRPC_PORT=5553",
    "METRICS_PORT=9253",
    "HEALTHCHECK_URL=127.0.0.1:${local.service_port}",
    "HEALTHCHECK_QUESTION=${local.healthcheck_question}",
    "HEALTHCHECK_TYPE=udp",
  ]

  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/certs": docker_volume.certs.name
  }

  # Service
  dns_upstream_1          = length(var.upstream_ips) == 0 ? "tls://${local.defaults.upstream_ips[0]}" : "tls://${var.upstream_ips[0]}"
  dns_upstream_2          = length(var.upstream_ips) <= 1 ? "tls://${local.defaults.upstream_ips[1]}" : "tls://${var.upstream_ips[1]}"
  dns_upstream_name       = length(var.upstream_name) != 0 ? var.upstream_name : local.defaults.upstream_name

  # Healthcheck config
  healthcheck_question    = var.healthcheck
}

resource "docker_volume" "certs" {
  provider      = docker
  name          = "certs-${local.container_name}"
}
