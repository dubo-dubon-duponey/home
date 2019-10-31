# Airport station
resource "docker_container" "airport" {
  provider      = docker
  name          = local.host_airport
  image         = docker_image.airport.latest
  hostname      = "${local.host_airport}.${var.hostname}"

  network_mode  = var.network

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  env           = [
    "NAME=${var.airport_name}"
  ]

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
resource "docker_container" "homekit-alsa" {
  provider      = docker
  name          = local.host_volume
  image         = docker_image.homekit-alsa.latest
  hostname      = "${local.host_volume}.${var.hostname}"

  network_mode  = var.network

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  env = [
    "HOMEKIT_NAME=${var.airport_name}",
    "HOMEKIT_PIN=14041976",
    "ALSA_DEVICE=${var.alsa_device}",
  ]

  volumes {
    volume_name = docker_volume.homekit_alsa.name
    container_path = "/data"
  }

  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]

  dns           = var.dns

  restart       = "always"
  read_only     = true

  capabilities {
    drop = [
      "ALL"
    ]
  }
}

# RAAT receiver
resource "docker_container" "raat" {
  provider      = docker
  name          = local.host_raat
  image         = docker_image.raat.latest
  hostname      = "${local.host_raat}.${var.hostname}"

  network_mode  = var.network

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  volumes {
    volume_name = docker_volume.raat.name
    container_path = "/data"
  }

  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]

  dns           = var.dns

  restart       = "always"
  read_only     = true

  capabilities {
    drop = [
      "ALL"
    ]
  }
}
