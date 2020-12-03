# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "SERVER_HOST=${local.container_hostname}",
    "SERVER_NAME=${local.container_hostname}",
    "ELASTICSEARCH_HOSTS=${local.elastic_container}",
    "HEALTHCHECK_URL=http://${local.container_hostname}:5601/api/status?healthcheck",
  ]
  // If in bridge, and if we want to expose, which ports
  expose        = var.expose ? {
    (var.port): local.internal_port,
    5601 = 5601
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {
    "co.elastic.logs/module": "kibana",
    "co.elastic.logs/fileset": "log",
  }
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
    "/boot/optimize": docker_volume.xxx-hack.name,
  }

  # Service
  elastic_container     = var.elastic_container

  internal_port = (var.user == "root" ? var.port : 9200)
}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

variable "elastic_container" {
  description = "Where to find the elastic container"
  type        = string
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "xxx-hack" {
  provider      = docker
  name          = "xxx-hack-${local.container_name}"
}

variable "port" {
  description = "Main port to expose"
  type        = string
  default     = "9200"
}
