# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "ATHENS_DISK_STORAGE_ROOT=/tmp/athens",
    "ATHENS_STORAGE_TYPE=disk",
    "ATHENS_PORT=:${local.port}",
    "HEALTHCHECK_URL=http://127.0.0.1:${local.port}/?healthcheck=internal",
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
    "/tmp": docker_volume.tmp.name,
  }

  port          = (var.user == "root" ? var.port : 3000)

}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

variable "port" {
  description = "Main port to expose"
  type        = string
  default     = "80"
}

