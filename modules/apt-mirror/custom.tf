# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "MDNS_NAME=Dubo Apt Mirror",
    "MDNS_HOST=apt-mirror",
    "MDNS_TYPE=_apt._tcp",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    "REALM=Apt Mirror",
    "LOG_LEVEL=info",
    "PORT=${var.port}",

    "ARCHITECTURES=${var.architectures}",
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
    "/tmp": var.tmp_path,
  }
  volumes       = {
//    "/tmp": docker_volume.tmp.name
  }
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
  default     = "/home/container/data/apt-mirror"
}

variable "tmp_path" {
  description = "Host path for transient data"
  type        = string
  default     = "/home/container/data/apt-mirror/tmp"
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

variable "architectures" {
  description = "Which architectures in the mirrors"
  type        = string
  default     = "armel,armhf,arm64,amd64,i386,s390x,ppc64el"
}
/*
resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}
*/
