resource "docker_container" "roon" {
  provider      = docker
  name          = local.host_roon
  image         = docker_image.roon.latest
  hostname      = "${local.host_roon}.${var.hostname}"

  network_mode  = var.network

  labels        = {
    "co.elastic.logs/enabled": true,
  }

  mounts {
    target    = "/data"
    source    = var.data_path
    read_only = false
    type      = "bind"
  }

  mounts {
    target  = "/music"
    source  = var.music_path
    read_only = true
    type    = "bind"
  }

  /*
  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]
  */

  dns           = var.dns

  restart       = "always"
  read_only     = true

  capabilities {
    drop = [
      "ALL"
    ]
  }
}

