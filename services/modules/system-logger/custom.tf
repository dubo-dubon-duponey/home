# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = []
  env           = [
    "KIBANA_HOST=${var.kibana}",
    "ELASTICSEARCH_HOSTS=[\"${var.elastic}\"]",
    "ELASTICSEARCH_USERNAME=",
    "ELASTICSEARCH_PASSWORD=",
    "MODULES=system coredns",
    "HEALTHCHECK_URL=${local.healthcheck_url}",
  ]
  // If in bridge, and if we want to expose, which ports
  expose        = {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {
  }
  mounts        = {
    "/var/log/auth.log": "/var/log/auth.log",
    "/var/log/syslog": "/var/log/syslog",
    "/var/lib/docker/containers": "/var/lib/docker/containers",
    "/var/run/docker.sock": "/var/run/docker.sock",
  }
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
    "/certs": docker_volume.certs.name,
  }

  # Healthcheck config
  healthcheck_url         = "http://${var.elastic}"
}

resource "docker_volume" "certs" {
  provider      = docker
  name          = "certs-${local.container_name}"
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

# Service specific configuration
variable "elastic" {
  description = "Elastic endpoint"
  type        = string
}

variable "kibana" {
  description = "Kibana endpoint"
  type        = string
}
