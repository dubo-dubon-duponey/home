# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = []
  // If in bridge, and if we want to expose, which ports
  expose        = var.expose ? {
    (var.port): local.internal_port,
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {
    "co.elastic.logs/module": "elasticsearch",
  }
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
    "/config": docker_volume.config.name,
    "/tmp": docker_volume.tmp.name,
  }

  internal_port = (var.user == "root" ? var.port : 9200)
}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "config" {
  provider      = docker
  name          = "config-${local.container_name}"
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

variable "port" {
  description = "Main port to expose"
  type        = string
  default     = "9200"
}
