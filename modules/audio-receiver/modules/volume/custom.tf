# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = [
    "/dev/snd",
  ]
  env           = [
    "HOMEKIT_NAME=${var.station}",
    "HOMEKIT_PIN=14041976",
    "ALSA_DEVICE=${var.device}",
    "ALSA_CARD=${var.card}",
  ]
  expose        = {}
  expose_type   = "tcp"
  group_add     = [
    "audio",
  ]
  labels        = {}
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name
  }
}

# Service settings
variable "station" {
  description = "HomeKit device name"
  type        = string
  default     = "Croquettas Ballas"
}

variable "device" {
  description = "Alsa device"
  type        = string
  default     = "PCM"
}

variable "card" {
  description = "Alsa card"
  type        = string
  default     = "0"
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}
