# Local indirection
locals {
  container_expose = {}

  env           = [
    "NAME=${var.station}",
    "PORT=10042",
  ]

  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }
  ramdisks      = {}
}

# Volumes
resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

# Service settings
variable "station" {
  description = "Spotify station name"
  type        = string
  default     = "Spotty Croquette"
}
