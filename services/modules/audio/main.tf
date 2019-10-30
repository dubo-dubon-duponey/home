# Airport station
data "docker_registry_image" "audio-airport" {
  name = local.image_airport_server
}

resource "docker_image" "airport" {
  provider      = docker
  name          = data.docker_registry_image.audio-airport.name
  pull_triggers = [data.docker_registry_image.audio-airport.sha256_digest]
}

resource "docker_container" "airport-croquette" {
  provider      = docker
  name          = local.host_airport
  image         = docker_image.airport.latest
  hostname      = "${local.host_airport}.${var.hostname}"

  network_mode  = var.network

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  env           = ["NAME=${var.airport_name}"]

  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio",
  ]

  command       = var.airport_cmd

  dns           = var.dns

  restart       = "always"
  read_only     = true

  capabilities {
    drop = [
      "ALL"
    ]
  }
}

# Homekit volume control
data "docker_registry_image" "homekit-alsa" {
  name = local.image_volume_control
}

resource "docker_image" "homekit-alsa" {
  provider = docker
  name = data.docker_registry_image.homekit-alsa.name
  pull_triggers = [
    data.docker_registry_image.homekit-alsa.sha256_digest]
}

