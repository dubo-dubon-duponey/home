###########################
# Roon server
###########################
module "media-server-roon" {
  source        = "../modules/roon"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  data_path     = "${var.volumes_root}/data/roon"
  music_path    = "/home/data/audio"

}

###########################
# Plex server
###########################
module "media-server-plex" {
  source        = "../modules/plex"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  data_path     = "${var.volumes_root}/data/plex"
  movie_path    = "/home/big/Sin/"

  login         = var.plex_login
  password      = var.plex_password
  station       = var.plex_server_name
  public_ip     = var.public_ip
  email         = var.email
}

###########################
# Wiz bulbs controller
###########################
module "wiz" {
  source        = "../modules/wiz"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  station       = "Whiz Bang "
}
