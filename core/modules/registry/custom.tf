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
  mountsrw      = {
    "/data": var.data_path,
  }
  volumes       = {}

  port          = (var.user == "root" ? var.port : 5000)
}



# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/registry"
}

variable "port" {
  description = "Main port to expose"
  type        = string
  default     = "5000"
}
