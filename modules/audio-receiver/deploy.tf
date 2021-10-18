module "airplay" {
  source = "./modules/airplay"
  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = []

  output    = "alsa"
  station   = var.station
  device    = var.device
}

module "raat" {
  source = "./modules/raat"
  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = var.dns
}

module "spotify" {
  source = "./modules/spotify"
  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = var.dns

  output = var.output
  station = var.station
  device = var.device

  display_enabled = var.display_enabled
  spotify_id = var.spotify_id
  spotify_secret = var.spotify_secret

  command = [
    /*"--alsa-mixer-control",
    var.mixer_name,
    "--alsa-mixer-device",
    "hw:${var.hw_index}",*/
    "--initial-volume",
    var.volume,
    "--enable-volume-normalisation",
  ]
}

/*
2021-10-01
Somehow, recent changes on our side made it so we lost the audio (alsa device/soundcard pointer is wrong?)
XXX or it was just the nightingale snaff
Also, pairing does not work with mobiles anymore
https://github.com/openairplay/goplay2/issues/29
Abandoning this - this is simply not ready yet

module "airplay2" {
  source = "./modules/airplay"

  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = var.dns

  station   = "[EXPERIMENTAL] ${var.station}"
  _experimental_protocol_version = 2
  command   = []
  nickname  = "airplay2"

  # XXX rationalize all this garbage
  alsa_device = "default:CARD=${var.card_name}"
}
*/

/*
module "volume" {
  source = "./modules/volume"

  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = var.dns

  station = var.station
  device = var.mixer_name
  card = var.hw_index
}
*/
