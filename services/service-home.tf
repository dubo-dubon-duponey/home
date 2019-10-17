# Images
resource "docker_image" "home-bridge-dac" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.home-bridge.name
  pull_triggers = [data.docker_registry_image.home-bridge.sha256_digest]
}

resource "docker_image" "home-bridge-nuc" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.home-bridge.name
  pull_triggers = [data.docker_registry_image.home-bridge.sha256_digest]
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

# Containers
resource "docker_container" "home-bridge-dac" {
  provider  = docker.dacodac
  name      = "bridge"
  image     = docker_image.home-bridge-dac.latest

  restart   = "always"
  network_mode  = docker_network.dac_hackvlan.name

  env = [
    "AVAHI_NAME=${local.dac_host}-bridge",
  ]

  mounts {
    target  = "/root/.homebridge"
    source  = "/home/data/config/homebridge"
    read_only = false
    type    = "bind"
  }

  # Required by the volume controller
  devices {
    host_path = "/dev/snd"
  }
}

// Second homebridge is there solely for volume control of the DAC - not super useful
resource "docker_container" "home-bridge-nuc" {
  provider  = docker.nucomedon
  name      = "bridge"
  image     = docker_image.home-bridge-nuc.latest

  restart   = "always"
  network_mode  = docker_network.nuc_hackvlan.name

  env = [
    "AVAHI_NAME=${local.nuc_host}-bridge",
  ]

  mounts {
    target  = "/root/.homebridge"
    source  = "/home/data/config/homebridge"
    read_only = false
    type    = "bind"
  }

  # Required by the volume controller
  devices {
    host_path = "/dev/snd"
  }
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
