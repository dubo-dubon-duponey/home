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

  /*
  volumes {
    volume_name = docker_volume.roon-data.name
    container_path = "/data"
  }
  */

  volumes {
    volume_name = docker_volume.tmp.name
    container_path = "/tmp"
  }


  mounts {
    target    = "/data"
    source    = local.mount_data
    read_only = false
    type      = "bind"
  }

  mounts {
    target  = "/music"
    source  = local.mount_music
    read_only = true
    type    = "bind"
  }

  // Only useful if one needs Roon to also be able to play on the device - and requires Roon to be built with libasound2 (currently not)
  /*
  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]
  */
}

