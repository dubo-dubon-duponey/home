# Local indirection
locals {
  container_expose = {}

  env           = [
    "MODE=client",
    "MDNS_NSS_ENABLED=${var.mdns_nss}",
    "SNAPCAST_SERVER=${var.master}",
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

variable "master" {
  description = "IP or host name of the snap server to hook-up with"
  type = string
  default = ""
}

variable "mdns_nss" {
  description = "Whether to enable avahi resolution"
  type        = bool
  default     = true
}
