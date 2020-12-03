# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = [
    // Only useful if one needs Roon to also be able to play on the device - and requires Roon to be built with libasound2 (currently not)
    // "/dev/snd"
  ]
  env           = []
  expose        = {}
  expose_type   = "tcp"
  group_add     = [
    // Only useful if one needs Roon to also be able to play on the device - and requires Roon to be built with libasound2 (currently not)
    // "audio"
  ]
  labels        = {}
  mounts        = {
    "/music": var.music_path,
  }
  mountsrw      = {
    "/data": var.data_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }
}

# Service specific configuration
variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
}

variable "music_path" {
  description = "Host path for mounted music collection folder"
  type        = string
}

/*
resource "docker_volume" "roon-data" {
  provider      = docker
  name          = "data-roon"
}
*/

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}
