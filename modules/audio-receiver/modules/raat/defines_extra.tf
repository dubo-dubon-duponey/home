# Local indirection
locals {
  container_expose = {}

  env = []

  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
  }
  ramdisks      = {
    "/tmp": "1M"
  }
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}
