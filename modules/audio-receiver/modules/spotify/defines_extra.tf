# Local indirection
locals {
  container_expose = {}

  env           = [
    "NAME=${var.station}",
    "PORT=10042",
  ]

  mounts        = {}
  mountsrw      = {
    "/pipes": var.pipes_path,
  }
  volumes       = {
    // This is becoming big very fast (1GB), too big for tmfs
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

variable "pipes_path" {
  description = "Path for sound pipe"
  type        = string
}
