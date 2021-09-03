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

  station = var.station

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
