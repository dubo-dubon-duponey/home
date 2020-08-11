/*
module "network" {
  source    = "./modules/network"
  providers = {
    docker  = docker.nucomedon
  }

  driver    = "macvlan"
  subnet    = local.subnet
  gateway   = local.gateway
  range     = local.nuc.range
  interface = local.nuc.iface
}
*/
