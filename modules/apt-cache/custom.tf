# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "MDNS_NAME=Dubo Apt Cacher",
    "MDNS_HOST=apt-cache",
    "MDNS_TYPE=_apt._tcp",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    "REALM=Apt Cacher",
    "LOG_LEVEL=info",
    "PORT=${var.port}",
  ]
  expose        = var.expose ? {
    (var.port): var.port
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {}
  mountsrw      = {
    "/data": var.data_path,
  }
  volumes       = {}
}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

variable "data_path" {
  description = "Host path for persistent writable data"
  type        = string
  default     = "/home/container/data/apt-cache"
}

variable "port" {
  description = "Port"
  type        = string
  default     = "8080"
}

variable "username" {
  description = "Restricted access to username"
  type        = string
}

variable "password" {
  description = "Restricted access password"
  type        = string
}
