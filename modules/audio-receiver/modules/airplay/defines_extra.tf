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

# Local indirection
locals {
  container_expose = {}

  env           = [
    "MDNS_NAME=${var.station}",
    "LOG_LEVEL=${var.log_level}",
    "PORT=5000",
    "OUTPUT=alsa",
    "DEVICE=${var.device}",
    "_EXPERIMENTAL_AIRPLAY_VERSION=${var._experimental_protocol_version}",
  ]

  mounts        = {}
  mountsrw      = {}

  // Just for goplay
  ramdisks      = {
    "/tmp": "1000000"
  }

  // Just for goplay (because dbus)
  volumes       = {
    "/run": docker_volume.run.name,
  }
}

# This is just for goplay
resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}

# Enabling goplay
variable "_experimental_protocol_version" {
  description = "Airplay protocol version"
  type        = number
  default     = 1

  validation {
    condition     = var._experimental_protocol_version > 0  && var._experimental_protocol_version < 3
    error_message = "Only version 1 or 2 are supported."
  }
}
