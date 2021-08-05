# Local indirection
locals {
  container_expose = {}

  env = []

  mounts        = {}
  mountsrw      = {}
  ramdisks      = {
    "/tmp": "1M"
  }
  volumes       = {
    "/data": docker_volume.data.name,
  }
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}
