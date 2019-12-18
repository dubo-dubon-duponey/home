# RAAT receiver
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

  volumes {
    volume_name = docker_volume.data.name
    container_path = "/data"
  }

  volumes {
    volume_name = docker_volume.tmp.name
    container_path = "/tmp"
  }

  devices {
    host_path = "/dev/snd"
  }

  group_add = [
    "audio"
  ]
}
