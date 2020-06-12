module "airport" {
  source = "./modules/airport"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
  user = var.user

  station = var.station
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
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
  user = var.user

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
  ]
}

module "raat" {
  source = "./modules/raat"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
  user = var.user
}

module "volume" {
  source = "./modules/volume"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
  user = var.user

  station = var.station
  device = var.mixer_name
  card = var.hw_index
}
