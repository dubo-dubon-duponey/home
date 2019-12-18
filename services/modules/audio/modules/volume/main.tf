# Homekit volume control
resource "docker_container" "container" {
  provider      = docker
  image         = docker_image.image.latest

  name          = local.container_name
  hostname      = local.container_hostname
  network_mode  = local.container_network
  dns           = local.container_dns
  user          = local.container_user

  restart       = "always"
  read_only     = true

  capabilities {
    drop  = ["ALL"]
  }

  labels        = {
    "co.elastic.logs/enabled": local.log,
  }

  env = [
    "HOMEKIT_NAME=${local.station}",
    "HOMEKIT_PIN=14041976",
    "ALSA_DEVICE=${local.device}",
    "ALSA_CARD=${local.card}",
  ]

  volumes {
    volume_name = docker_volume.data.name
    container_path = "/data"
  }

  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]
}
