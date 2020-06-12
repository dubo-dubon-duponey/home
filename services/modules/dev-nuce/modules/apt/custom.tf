# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
  ]
  expose        = var.expose ? {
    3142: 3142
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
  }
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
