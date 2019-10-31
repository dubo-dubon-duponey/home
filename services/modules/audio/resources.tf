# Volumes
resource "docker_volume" "homekit_alsa" {
  provider      = docker
  name          = "homekit-alsa"
}

resource "docker_volume" "raat" {
  provider      = docker
  name          = "raat"
}

# Images
resource "docker_image" "airport" {
  provider      = docker
  name          = data.docker_registry_image.airport.name
  pull_triggers = [data.docker_registry_image.airport.sha256_digest]
}

resource "docker_image" "homekit-alsa" {
  provider = docker
  name = data.docker_registry_image.homekit-alsa.name
  pull_triggers = [
    data.docker_registry_image.homekit-alsa.sha256_digest]
}
resource "docker_image" "raat" {
  provider      = docker
  name          = data.docker_registry_image.raat.name
  pull_triggers = [data.docker_registry_image.raat.sha256_digest]
}
