module "network-nuc" {
  source    = "./modules/network"
  providers = {
    docker  = docker.nucomedon
  }

  driver    = "macvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.nuc_range
  interface = local.nuc_fact_iface
}

module "network-dac" {
  source    = "./modules/network"
  providers = {
    docker  = docker.dacodac
  }

  driver    = "macvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.dac_range
  interface = local.dac_fact_iface
}

module "network-nig" {
  source    = "./modules/network"
  providers = {
    docker  = docker.nightingale
  }

  driver    = "ipvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.nig_range
  interface = local.nig_fact_iface
}
