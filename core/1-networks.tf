module "network" {
  source    = "./modules/network"
  providers = {
    docker  = docker.nucomedon
  }

  driver    = local.nuc.driver
  range     = local.nuc.range
  interface = local.nuc.iface
  subnet    = local.subnet
  gateway   = local.gateway
}
