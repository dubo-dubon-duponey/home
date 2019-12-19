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
    "DBDB_LOGIN=${local.login}",
    "DBDB_PASSWORD=${var.password}",
    "DBDB_ADVERTISE_IP=${var.public_ip}",
    "DBDB_MAIL=${var.email}",
    "DBDB_SERVER_NAME=${var.station}"
  ]

  ports {
    internal    = 32400
    external    = 32400
  }

  /*
  volumes {
    volume_name = docker_volume.roon-data.name
    container_path = "/data"
  }
  */

  # For transcode and other tmp stuff
  volumes {
    volume_name = docker_volume.tmp.name
    container_path = "/transcode"
  }

  # For config and db, which needs to be updated...
  mounts {
    target    = "/data"
    source    = local.mount_data
    read_only = false
    type      = "bind"
  }

  # Media stuff
  mounts {
    target  = "/media"
    source  = local.mount_music
    read_only = true
    type    = "bind"
  }

  mounts {
    target      = "/incoming"
    source      = "/home/big/Incoming"
    read_only   = true
    type        = "bind"
  }

}

