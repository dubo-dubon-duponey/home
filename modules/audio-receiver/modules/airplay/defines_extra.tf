# Local indirection
locals {
  container_expose = {}

  env           = [
    "LOG_LEVEL=debug", // "${var.log_level}",

    "PORT=7000",

    // airplay mdns implementation is avahi dependent only
    "MOD_MDNS_NAME=${var.station}",

    "OUTPUT=${var.output}",
    "DEVICE=${var.device}",
  ]

  mounts        = {}
  mountsrw      = {}
  ramdisks      = {
    "/tmp": "1000000"
  }
  // Avahi... :/ not happy with a ramdisk...
  volumes       = {
    "/run/avahi-daemon": docker_volume.run.name
  }
}

# This is for avahi
resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}

# Service settings
variable "station" {
  description = "Airplay station name"
  type        = string
  default     = "Super Croquette"
}

variable "device" {
  description = "Alsa Device"
  type = string
  default = ""
}

variable "output" {
  description = "alsa / pipe, etc"
  type = string
  default = "alsa"
}
