module "media-receiver-dac" {
  source        = "./modules/media-receiver"
  providers     = {
    docker  = docker.dacodac
  }

  hostname      = local.dac.hostname

  networks      = {
    (module.network-dac.vlan): "",
  }

  dns           = [
    local.dac.dns_ip,
  ]

  station       = local.dac.audio_name
  hw_index      = local.dac.hw_index
  mixer_name    = local.dac.mixer_name
  card_name     = local.dac.card_name
  volume        = local.dac.volume
}

module "media-receiver-nig" {
  source        = "./modules/media-receiver"
  providers     = {
    docker  = docker.nightingale
  }

  hostname      = local.nig.hostname

  networks      = {
    (module.network-nig.vlan): "",
  }

  dns           = [
    local.nig.dns_ip,
  ]

  station       = local.nig.audio_name
  hw_index      = local.nig.hw_index
  mixer_name    = local.nig.mixer_name
  card_name     = local.nig.card_name
  volume        = local.nig.volume
}

// Moved from the nuc
module "media-receiver-cor" {
  source        = "./modules/media-receiver"
  providers     = {
    docker  = docker.corpisone
  }

  hostname      = local.cor.hostname

  networks      = {
    (module.network-cor.vlan): "",
  }

  dns           = [
    local.cor.dns_ip,
  ]

  station       = local.cor.audio_name
  hw_index      = local.cor.hw_index
  mixer_name    = local.cor.mixer_name
  card_name     = local.cor.card_name
  volume        = local.cor.volume
}

###########################
# Roon server
###########################
module "media-server-roon" {
  source        = "./modules/media-roon"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    local.nuc.dns_ip,
  ]

  data_path     = "${var.volumes_root}/data/roon"
  music_path    = "/home/data/audio"
}

###########################
# Plex server
###########################
module "media-server-plex" {
  source        = "./modules/media-plex"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  # network       = module.network-nuc.vlan
  networks      = {
    (module.network-nuc.vlan): "", # XXX ideally bridge, to better control networking, but...
  }

  dns           = [
    local.nuc.dns_ip,
  ]

  data_path     = "${var.volumes_root}/data/plex"
  movie_path    = "/home/big/Future/"

  login         = var.plex_login
  password      = var.plex_password
  public_ip     = var.public_ip
  email         = var.email
  station       = var.plex_server_name
}
