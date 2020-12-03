# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
#    "USERNAME_ADMIN=admin",
#    "PASSWORD_ADMIN=${var.password}",
    "SALT=eW91IGFyZSBzbyBzbWFydAo=",
    "PULL=authenticated",
    "PUSH=disabled",
    "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/data",
    "PORT=${local.internal_port}"
  ]
  expose        = var.expose ? {
    (var.port): local.internal_port,
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {}
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }

  internal_port = (var.user == "root" ? var.port : 4443)
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

variable "username" {
  description = "Restricted access to username"
  type        = string
}

variable "password" {
  description = "Restricted access password"
  type        = string
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/registry"
}

variable "cert_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/certs/registry"
}

variable "port" {
  description = "Main port to expose"
  type        = string
  default     = "443"
}
