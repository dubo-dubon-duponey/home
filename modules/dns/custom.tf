# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "DOMAIN=",
    "EMAIL=",
    "UPSTREAM_SERVER_1=${local.dns_upstream_1}",
    "UPSTREAM_SERVER_2=${local.dns_upstream_2}",
    "UPSTREAM_NAME=${local.dns_upstream_name}",
    "STAGING=",
    "DNS_PORT=${local.dns_port}",
    "TLS_PORT=1853",
    "HTTPS_PORT=1443",
    "GRPC_PORT=5553",
    "METRICS_PORT=9253",
    "HEALTHCHECK_URL=127.0.0.1:${local.dns_port}",
    "HEALTHCHECK_QUESTION=${local.healthcheck_question}",
    "HEALTHCHECK_TYPE=udp",
  ]
  // If in bridge, and if we want to expose, which ports
  expose        = var.expose ? {
    53 = local.dns_port
  } : {}
  expose_type   = "udp"
  group_add     = []
  labels        = {
    "co.elastic.logs/module": "coredns",
    "co.elastic.logs/fileset": "log",
  }
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/certs": docker_volume.certs.name
  }

  # Service
  dns_upstream_1          = length(var.upstream_ips) == 0 ? "tls://${local.defaults.upstream_ips[0]}" : "tls://${var.upstream_ips[0]}"
  dns_upstream_2          = length(var.upstream_ips) <= 1 ? "tls://${local.defaults.upstream_ips[1]}" : "tls://${var.upstream_ips[1]}"
  dns_upstream_name       = length(var.upstream_name) != 0 ? var.upstream_name : local.defaults.upstream_name

  dns_port                = var.user == "root" ? 53 : 1053

  # Healthcheck config
  # XXX that should be configurable
  healthcheck_question    = var.healthcheck
}

# Service settings
variable "upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = ""
}

variable "upstream_ips" {
  description = "Upstream TLS DNS server ips"
  type        = list(string)
  default     = []
}

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = true
}

variable "healthcheck" {
  description = "Domain name to resolve for the healthchecked"
  type        = string
  default     = "dns.healthcheck.jsboot.space"
}

resource "docker_volume" "certs" {
  provider      = docker
  name          = "certs-${local.container_name}"
}
