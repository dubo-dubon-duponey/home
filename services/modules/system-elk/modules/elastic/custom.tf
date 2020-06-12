# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = []
  env           = []
  // If in bridge, and if we want to expose, which ports
  expose        = var.expose ? {
    9200 = 9200
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
}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = true
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

