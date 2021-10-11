# Local indirection
locals {
  container_expose = {}

  env           = [
    "MDNS_NAME=${var.station}",
    "AIRPLAY_VERSION=${var.protocol_version}",
    "LOG_LEVEL=${var.log_level}",
    "PORT=5000",
    "OUTPUT=alsa",
    "DEVICE=${var.alsa_device}",
  ]

  mounts        = {}
  mountsrw      = {}
  ramdisks      = {
    "/tmp": "1000000"
  }
  // Just for goplay (because dbus)
  volumes       = {
    "/run": docker_volume.run.name,
  }
}

# Service settings
variable "station" {
  description = "Airplay station name"
  type        = string
  default     = "Super Croquette"
}

# This is just for goplay (for now)
resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}

# Service settings
variable "protocol_version" {
  description = "Airplay protocol version"
  type        = number
  default     = 1

  validation {
    condition     = var.protocol_version > 0  && var.protocol_version < 3
    error_message = "Only version 1 or 2 are supported."
  }
}
variable "alsa_device" {
  description = "Alsa Device"
  type = string
  default = "default"
}
