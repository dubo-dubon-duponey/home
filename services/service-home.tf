resource "docker_container" "homekit-alsa-dac" {
  provider  = docker.dacodac
  name      = "homekit-alsa"
  image     = docker_image.homekit-alsa-dac.latest

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
  name      = "homekit-alsa"
  image     = docker_image.homekit-alsa-nig.latest

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
  name      = "homebridge"
  image     = docker_image.homebridge-dac.latest

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

  # Required by the volume controller
  devices {
    host_path = "/dev/snd"
  }

  restart       = "always"
#  read_only     = true
  capabilities {
    drop        = ["ALL"]
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


/*
resource "docker_image" "home-automation" {
  depends_on = [
    null_resource.nuc,
  ]
  provider      = docker.nucomedon
  name          = data.docker_registry_image.home-automation.name
  pull_triggers = [data.docker_registry_image.home-automation.sha256_digest]
}
*/

resource "docker_image" "home-share" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.home-share.name
  pull_triggers = [data.docker_registry_image.home-share.sha256_digest]
}

resource "docker_container" "home-share" {
  depends_on = [
    random_string.afp_pwd,
  ]

  provider  = docker.nucomedon
  name      = "share"
  image     = docker_image.home-share.latest

  restart   = "always"
  network_mode  = docker_network.nuc_hackvlan.name

  env = [
    "USERS=${var.afp_user}",
    "PASSWORDS=${random_string.afp_pwd.result}",
    "NAME=${var.afp_server_name}",
    "AVAHI_NAME=${local.nuc_host}-share",
  ]

  mounts {
    target  = "/media/timemachine"
    source  = "/home/volatile/timemachine"
    read_only = false
    type    = "bind"
  }

  mounts {
    target  = "/media/share"
    source  = "/home/data/share"
    read_only = false
    type    = "bind"
  }

  mounts {
    target  = "/media/home"
    source  = "/home/data/home"
    read_only = false
    type    = "bind"
  }

  provisioner "local-exec" {
    command = "echo 'AFP configured with password: ${random_string.afp_pwd.result}'"
  }
}


# Not that interesting for now - need more work maybe?
#resource "docker_container" "home-automation" {
#  provider  = docker.nucomedon
#  name      = "home-automation"
#  image     = docker_image.home-automation.latest
#  restart   = "always"
#  ports     {
#    internal = 8123
#    external = 8123
#  }
#  network_mode = "host"
#  env = [
#  ]
#
#  mounts {
#    target  = "/root/.homeassistant"
#    source  = "/home/data/config/homeassistant"
#    read_only = false
#    type    = "bind"
#  }
#}

# XXX logdna
# docker run --name='logdna' --restart=always -d -v=/var/run/docker.sock:/var/run/docker.sock -e LOGDNA_KEY="f48c0089b2501d95ca0f9d4808936d4b" logdna/logspout:latest
