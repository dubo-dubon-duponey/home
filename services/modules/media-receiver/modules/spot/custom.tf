# Local indirection
locals {
  capabilities  = []
  command       = var.command
  devices       = [
    "/dev/snd",
  ]
  env           = [
    "NAME=${var.station}",
    "PORT=10042",
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
    "/tmp": docker_volume.tmp.name
  }
}

# Service settings
variable "station" {
  description = "Spotify station name"
  type        = string
  default     = "Spotty Croquette"
}

variable "command" {
  description = "Extra command line arguments"
  type        = list(string)
  default     = [
    "--device", "default", # as seen with librespot --name foo --device ?
    "--mixer-name", "PCM", # defaults to PCM
    "--mixer-card", "hw:0", # (from aplay -l - defaults to default)
    "--initial-volume", "75",
    "--enable-volume-normalisation",
    "-v",
  ]
}

# Volumes
resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}
