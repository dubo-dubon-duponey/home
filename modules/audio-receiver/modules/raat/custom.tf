# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = [
    "/dev/snd",
  ]
  env           = []
  expose        = {}
  expose_type   = "tcp"
  group_add     = [
    "audio",
  ]
  labels        = {}
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
    "/tmp": docker_volume.tmp.name,
  }
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}
