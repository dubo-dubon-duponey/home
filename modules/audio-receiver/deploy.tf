module "airplay" {
  source = "./modules/airplay"

  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = var.dns

  station   = var.station
  command = [
    # "-vv",
    # "--statistics",
    "--",
    "-d",
    "hw:${var.hw_index}",
  ]

}

/*
2021-10-01
Somehow, recent changes on our side made it so we lost the audio (alsa device/soundcard pointer is wrong?)
Also, pairing does not work with mobiles anymore
https://github.com/openairplay/goplay2/issues/29
Abandoning this - this is simply not ready
Shame

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
  protocol_version = 2
  command   = []
  nickname  = "airplay2"

  # XXX rationalize all this garbage
  alsa_device = "default:CARD=${var.card_name}"
}
*/

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

  station = var.station

  display_enabled = var.display_enabled
  spotify_id = var.spotify_id
  spotify_secret = var.spotify_secret
  pipes_path = "/home/container/pipes"
/*  command = [
    # XXX really dirty
    "--backend", "pipe", "--device", "/pipes/librespot_pipe"
  ]*/
  command = [
    "--device",
    "default:CARD=${var.card_name}",
    "--mixer-name",
    var.mixer_name,
    "--mixer-card",
    "hw:${var.hw_index}",
    "--initial-volume",
    var.volume,
    "--enable-volume-normalisation",
    // "-v",
  ]
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
