###########################
# Audio nodules
###########################
module "audio-dac" {
  source            = "./modules/audio"
  providers         = {
    docker  = docker.dacodac
  }

  network           = module.network-dac.vlan
  hostname          = "dacodac.container"
  dns               = [module.dns-dac.ip]

  spot_name         = "${var.dac_audio_name}, Spot"
  spot_cmd          = [
    "--mixer-name", "Digital",
    "--mixer-card", "hw:0",
    "--enable-volume-normalisation",
    "--initial-volume", "100",
    "-v",
  ]

  airport_name      = "${var.dac_audio_name}, Air"
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

  spot_name         = "${var.nuc_audio_name}, Spot"
  spot_cmd          = [
    "--device", "default:CARD=Mojo",
    "--mixer-name", "PCM",
    "--mixer-card", "hw:1",
#    "--enable-volume-normalisation",
#    "--initial-volume", "75",
    "-v",
  ]

  airport_name      = "${var.nuc_audio_name}, Air"
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

  spot_name         = "${var.nig_audio_name}, Spot"
  spot_cmd          = [
    "--device", "hw:CARD=DACE17,DEV=1",
    "--mixer-name", "PCM",
    "--mixer-card", "hw:1",
    "--enable-volume-normalisation",
    "--initial-volume", "50",
    "-v",
  ]

  airport_name      = "${var.nig_audio_name}, Air"
  airport_cmd       = [
    "-vv",
    "--statistics",
    "--",
    "-d",
    "hw:1",
  ]
  alsa_device       = "PCM"
}

###########################
# Roon server
###########################
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
