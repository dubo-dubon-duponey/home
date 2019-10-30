module "audio-dac" {
  source              = "./modules/audio"
  providers           = {
    docker  = docker.dacodac
  }

  network           = module.network-dac.vlan
  hostname          = "dacodac.container"
  dns               = [module.core-nuc.dns_server_ip]

  airport_name      = var.airport_dac_name
  airport_cmd       = [
    "-vv",
    "--statistics",
  ]
  alsa_device       = "Digital"
}

module "audio-nuc" {
  source              = "./modules/audio"
  providers           = {
    docker  = docker.nucomedon
  }

  network           = module.network-nuc.vlan
  hostname          = "nucomedon.container"
  dns               = [module.core-dac.dns_server_ip]

  airport_name      = var.airport_nuc_name
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
  source              = "./modules/audio"
  providers           = {
    docker  = docker.nightingale
  }

  network           = module.network-nig.vlan
  hostname          = "nightingale.container"
  dns               = [module.core-nuc.dns_server_ip]

  airport_name      = var.airport_nig_name
  airport_cmd       = [
    "-vv",
    "--statistics",
    "--",
    "-d",
    "hw:1",
  ]
  alsa_device       = "PCM"
}
