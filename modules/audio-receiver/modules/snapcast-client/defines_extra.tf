# Local indirection
locals {
  container_expose = {}

  env           = [
    "MODE=client",
    "MDNS_NSS_ENABLED=true",
    "SNAPCAST_SERVER=${var.server}",
    "DEVICE=${var.device}",
    "MIXER=${var.mixer}",
  ]

  mounts        = {}
  mountsrw      = {
  }
  volumes       = {
    "/data": docker_volume.data.name
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

variable "device" {
  description = "Alsa Device"
  type = string
  default = ""
}

variable "mixer" {
  description = "Name of mixer (hardware)"
  type = string
  default = ""
}

variable "server" {
  description = "IP or host name of the snap server to hook-up with"
  type = string
  default = ""
}
