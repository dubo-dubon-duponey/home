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

  /*
  subnet    = "2002:c0a8:100::/124"
  gateway   = "2002:c0a8:101::"
  range     = "2002:c0a8:150::/60"

  subnet    = "2001:3200:3200::/64"
  gateway   = "2001:3200:3200::1"
  range     = "2001:3200:3200::10/60"
*/
  # From Docker documentation
  # 2001:db8:1::/64
}
