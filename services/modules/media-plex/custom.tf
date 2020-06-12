# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = []
  env           = [
    "DBDB_LOGIN=${var.login}",
    "DBDB_PASSWORD=${var.password}",
    "DBDB_ADVERTISE_IP=${var.public_ip}",
    "DBDB_MAIL=${var.email}",
    "DBDB_SERVER_NAME=${var.station}"
  ]
  expose        = var.expose ? {
    32400: 32400
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {
    "/media": var.movie_path
  }
  # For config and db, with write access and should be preserved durably
  # XXX maybe a volume would be enough?
  mountsrw      = {
    "/data": var.data_path
  }
  volumes       = {
    "/transcode": docker_volume.tmp.name
  }
}

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

# Service specific configuration
variable "data_path" {
  description = "Host path for persistent config"
  type        = string
  default     = "/home/container/data/plex"
}

variable "movie_path" {
  description = "Host path for mounted movie collection folder"
  type        = string
  default     = "/home/data/movie"
}

variable "login" {
  description = "Plex login"
  type        = string
  default     = "dmp"
}

variable "password" {
  description = "Plex password"
  type        = string
  default     = "nhehehehe"
}

variable "public_ip" {
  description = "Plex publicly visible ip (defaults to myip.opendns.com)"
  type        = string
  default     = ""
}

variable "email" {
  description = "Your email"
  type        = string
  default     = "you@me.com"
}

variable "station" {
  description = "Plex Station Name"
  type        = string
  default     = "Plexouille"
}

resource "docker_volume" "config" {
  provider      = docker
  name          = "config-${local.container_name}"
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}
