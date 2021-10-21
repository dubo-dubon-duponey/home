# Local indirection
locals {
  container_expose = {}

  env           = [
    "MODE=client",
    // Server name to find
    // XXX hardcoded for now
    "MDNS_HOST=snappy",
  ]

  mounts        = {}
  mountsrw      = {
    // "/pipes": var.pipes_path,
  }
  volumes       = {
    // This is becoming big very fast (1GB), too big for tmfs
    "/data": docker_volume.data.name
//    "/tmp": docker_volume.tmp.name
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

# Volumes
/*
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
*/
/*
variable "pipes_path" {
  description = "Path for sound pipe"
  type        = string
}
*/
