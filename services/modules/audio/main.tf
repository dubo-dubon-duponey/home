module "airport" {
  source = "./modules/airport"
  providers = {
    docker = docker
  }

  nickname = "airport"
  hostname = var.hostname
  log = var.log
  network = var.network
  dns = var.dns

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

  nickname = "spot"
  hostname = var.hostname
  log = var.log
  network = var.network
  dns = var.dns

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

  nickname = "raat"
  hostname = var.hostname
  log = var.log
  network = var.network
  dns = var.dns
}

module "volume" {
  source = "./modules/volume"
  providers = {
    docker = docker
  }

  nickname = "volume"
  hostname = var.hostname
  log = var.log
  network = var.network
  dns = var.dns

  station = var.station
  device = var.mixer_name
  card = var.hw_index
}
