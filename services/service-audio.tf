###########################
# Audio nodules
###########################
module "audio-dac" {
  source        = "./modules/audio"
  providers     = {
    docker  = docker.dacodac
  }

  hostname      = local.dac_hostname
  network       = module.network-dac.vlan
  dns           = [module.dns-dac.ip]
  log           = true

  station       = var.dac_audio_name
  hw_index      = 0
  mixer_name    = "Digital"
  card_name     = "sndrpihifiberry"
  volume        = 100
}

module "audio-nuc" {
  source        = "./modules/audio"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc_hostname
  network       = module.network-nuc.vlan
  dns           = [module.dns-nuc.ip]
  log           = true

  station       = var.nuc_audio_name
  hw_index      = 1
  mixer_name    = "PCM"
  card_name     = "Mojo"
  volume        = 100
}

/*
module "audio-nig" {
  source        = "./modules/audio"
  providers     = {
    docker  = docker.nightingale
  }

  hostname      = local.nig_hostname
  network       = module.network-nig.vlan
  dns           = [module.dns-nig.ip]
  log           = true

  station       = var.nig_audio_name
  hw_index      = 1
  mixer_name    = "PCM"
  card_name     = "DACE17,DEV=1"
  volume        = 100
}
*/

###########################
# Roon server
###########################
module "audio-roon" {
  source        = "./modules/roon"
  providers     = {
    docker  = docker.nucomedon
  }

  nickname      = "roon"
  hostname      = local.nuc_hostname
  network       = module.network-nuc.vlan
  dns           = [module.dns-nuc.ip]
  log           = true

  data_path     = "${var.volumes_root}/data/roon"
  music_path    = "/home/data/audio"
}
