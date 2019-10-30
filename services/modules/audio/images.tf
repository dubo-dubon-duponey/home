data "docker_registry_image" "airport" {
  name = local.image_airport_server
}

resource "docker_image" "airport" {
  provider      = docker
  name          = data.docker_registry_image.airport.name
  pull_triggers = [data.docker_registry_image.airport.sha256_digest]
}

data "docker_registry_image" "homekit-alsa" {
  name = local.image_volume_control
}

resource "docker_image" "homekit-alsa" {
  provider = docker
  name = data.docker_registry_image.homekit-alsa.name
  pull_triggers = [
    data.docker_registry_image.homekit-alsa.sha256_digest]
}

data "docker_registry_image" "raat" {
  name = local.image_raat_server
}

resource "docker_image" "raat" {
  provider      = docker
  name          = data.docker_registry_image.raat.name
  pull_triggers = [data.docker_registry_image.raat.sha256_digest]
}

