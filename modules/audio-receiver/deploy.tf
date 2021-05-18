module "airport" {
  source = "./modules/airport"

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

module "spot" {
  source = "./modules/spot"

  registry = var.registry
  providers = {
    docker = docker
  }
  hostname  = var.hostname
  log       = var.log
  networks  = var.networks
  dns       = var.dns

  station = var.station
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
    "-v",
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
