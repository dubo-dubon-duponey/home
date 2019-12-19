resource "docker_container" "container" {
  provider      = docker
  image         = docker_image.image.latest

  name          = local.container_name
  hostname      = local.container_hostname
  network_mode  = local.container_network
  dns           = local.container_dns
  user          = local.container_user

  restart       = "always"
  # XXX right now, we have to have this
  read_only     = false

  capabilities {
    drop  = ["ALL"]
    add   = local.container_capabilities
  }

  labels        = {
    "co.elastic.logs/enabled": local.log,
  }

  volumes {
    volume_name = docker_volume.etc.name
    container_path = "/etc"
  }

  volumes {
    volume_name = docker_volume.log.name
    container_path = "/var/log"
  }

  volumes {
    volume_name = docker_volume.data.name
    container_path = "/data"
  }

  volumes {
    volume_name = docker_volume.run.name
    container_path = "/run"
  }

  env = [
    "USERS=${local.users}",
    "PASSWORDS=${local.passwords}",
    "NAME=${var.station}",
    "AVAHI_NAME=dubo-netatalk",
  ]

  provisioner "local-exec" {
    command = "echo 'Users haven been configured for netatalk: ${local.users} (${local.passwords}). This will never be displayed ever again.'"
  }

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
}
