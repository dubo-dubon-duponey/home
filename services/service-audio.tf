module "audio-dac" {
  source            = "./modules/audio"
  providers         = {
    docker  = docker.dacodac
  }

  network           = module.network-dac.vlan
  hostname          = "dacodac.container"
  dns               = [module.dns-dac.ip]

  airport_name      = var.dac_audio_name
  airport_cmd       = [
    "-vv",
    "--statistics",
  ]
  alsa_device       = "Digital"
}

module "audio-nuc" {
  source            = "./modules/audio"
  providers         = {
    docker  = docker.nucomedon
  }

  network           = module.network-nuc.vlan
  hostname          = "nucomedon.container"
  dns               = [module.dns-nuc.ip]

  airport_name      = var.nuc_audio_name
  airport_cmd       = [
    "-vv",
    "--statistics",
    "--",
    "-d",
    "hw:1",
  ]
  alsa_device       = "PCM"
}

module "audio-nig" {
  source            = "./modules/audio"
  providers         = {
    docker  = docker.nightingale
  }

  network           = module.network-nig.vlan
  hostname          = "nightingale.container"
  dns               = [module.dns-nig.ip]

  airport_name      = var.nig_audio_name
  airport_cmd       = [
    "-vv",
    "--statistics",
    "--",
    "-d",
    "hw:1",
  ]
  alsa_device       = "PCM"
}

module "audio-roon" {
  source            = "./modules/roon"
  providers         = {
    docker  = docker.nucomedon
  }

  network           = module.network-nuc.vlan
  hostname          = "nucomedon.container"
  dns               = [module.dns-nuc.ip]

  data_path         = "/home/container/data/roon"
  music_path        = "/home/data/audio"
}
