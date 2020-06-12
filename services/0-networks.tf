module "network-dac" {
  source    = "./modules/root-network"
  providers = {
    docker  = docker.dacodac
  }

  driver    = "ipvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.dac.range
  interface = local.dac.iface
}

module "network-nuc" {
  source    = "./modules/root-network"
  providers = {
    docker  = docker.nucomedon
  }

  driver    = "macvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.nuc.range
  interface = local.nuc.iface
}

module "network-nig" {
  source    = "./modules/root-network"
  providers = {
    docker  = docker.nightingale
  }

  driver    = "ipvlan"

  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.nig.range
  interface = local.nig.iface
}

module "network-cor" {
  source    = "./modules/root-network"
  providers = {
    docker  = docker.corpisone
  }

  driver    = "ipvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.cor.range
  interface = local.cor.iface
}

/*
module "network-mac" {
  source    = "./modules/root-network"
  providers = {
    docker  = docker.macarena
  }

  driver    = "ipvlan"

  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.mac.range
  interface = local.mac.iface
}
*/
