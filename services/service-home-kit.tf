resource "docker_container" "homekit-alsa-dac" {
  provider  = docker.dacodac
  name      = "homekit-sound"
  image     = docker_image.homekit-alsa-dac.latest
  hostname  = "homekit-sound.dacodac.container"

  network_mode  = docker_network.dac_hackvlan.name

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  env = [
    "HOMEKIT_NAME=${var.airport_dac_server_name}",
    "HOMEKIT_PIN=14041976",
  ]

  # Required by the volume controller
  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]

  depends_on    = [
    docker_container.dns_nuc
  ]
  dns           = [local.nuc_ip]

  restart       = "always"
  read_only     = true
  capabilities {
    drop = [
      "ALL"
    ]
  }
}

resource "docker_container" "homekit-alsa-nig" {
  provider  = docker.nightingale
  name      = "homekit-sound"
  image     = docker_image.homekit-alsa-nig.latest
  hostname  = "homekit-sound.nightingale.container"

  network_mode  = "host"

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  env = [
    "HOMEKIT_NAME=${var.airport_nig_server_name}",
    "HOMEKIT_PIN=14041976",
    "ALSA_DEVICE=PCM",
  ]

  # Required by the volume controller
  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]

  depends_on    = [
    docker_container.dns_nuc
  ]
  dns           = [local.nuc_ip]

  restart       = "always"
  read_only     = true
  capabilities {
    drop = [
      "ALL"
    ]
  }
}

/*
XXX The mojo does not support software volume, so, no nuc
*/

# Containers
resource "docker_container" "homebridge-dac" {
  provider  = docker.dacodac
  name      = "homekit-bridge"
  image     = docker_image.homebridge-dac.latest
  hostname  = "homekit-bridge.dacodac.container"

  network_mode  = docker_network.dac_hackvlan.name

  env = [
    "AVAHI_NAME=Homebridge (${local.dac_host})",
  ]

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  mounts {
    target  = "/config"
    source  = "/home/container/config/homebridge"
    read_only = true
    type    = "bind"
  }

  volumes {
    volume_name = docker_volume.homebridge_data_dac.name
    container_path = "/data"
  }

  depends_on    = [
    docker_container.dns_nuc
  ]
  dns           = [local.nuc_ip]

  restart       = "always"
  # XXX unfortunately can't do that on arm
  # read_only     = true
  capabilities {
    drop        = [
      "ALL"
    ]
    add         = [
      "SYS_CHROOT",
      "DAC_OVERRIDE",
      "FOWNER",
      "CHOWN",
      "SETUID",
      "SETGID",
    ]
  }
}
