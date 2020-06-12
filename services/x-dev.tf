module "dev" {
  source        = "./modules/dev-nuce"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    local.nuc.dns_ip,
  ]

  registry      = "https://registry.dev.jsboot.space"
}

module "dev" {
  source        = "./modules/dev-nuce"
  providers     = {
    docker  = docker.macarena
  }

  hostname      = local.mac.hostname

  networks      = {
    "bridge": "",
  }

  dns           = [
    local.mac.dns_ip,
  ]

  registry      = "https://registry.dev.jsboot.space"
}

