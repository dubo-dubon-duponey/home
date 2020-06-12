module "apt" {
  source = "./modules/apt"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
}

module "go" {
  source = "./modules/go"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
}

module "registry" {
  source = "./modules/registry"
  providers = {
    docker = docker
  }

  hostname = var.hostname
  log = var.log
  networks = var.networks
  dns = var.dns
}

