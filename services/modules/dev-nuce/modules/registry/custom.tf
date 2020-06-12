# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "REGISTRY_HTTP_ADDR=:${local.port}",
    "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/data",
  ]
  expose        = var.expose ? {
    (var.port): local.port,
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
  }

  port          = (var.user == "root" ? var.port : 5000)
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

variable "port" {
  description = "Main port to expose"
  type        = string
  default     = "5000"
}
