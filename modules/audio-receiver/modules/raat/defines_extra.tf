# Local indirection
locals {
  container_expose = {}

  env = []

  mounts   = {}
  mountsrw = {}
  ramdisks = {
    "/tmp" : "1000000"
  }
  volumes  = {
    "/data" : docker_volume.data.name,
    # XXX only roon server uses this, but they share a
    # start script for now
    "/certs" : docker_volume.certs.name
  }
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "certs" {
  provider      = docker
  name          = "certs-${local.container_name}"
}

