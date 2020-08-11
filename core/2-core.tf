###########################
# Core - base infrastructure needed for everything else to work
###########################

# First, a working DNS server - every other system on the nuc depends on this
/*
module "dns" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    // (module.network.vlan): local.nuc.dns_ip,
    "dubo-vlan": local.nuc.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "nuc.dns.healthcheck.jsboot.space"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips

  # registry      = module.registry.name
}
*/

# Then, a local registry, hopefully prepopulated with every required image
module "registry" {
  source        = "./modules/registry"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    // (module.network.vlan): "",
    "dubo-vlan": "",
  }

  dns           = [
    // module.dns.ip,
    local.nuc.dns_ip,
  ]

  data_path     = "${var.volumes_root}/data/registry"
}

# XXX annoyingly, this service cannot serve anything on macvlan on this same host
# One solution would be to serve these from dacodac instead
# Another would be to serve on host (assuming that even works)
# All this also begs the question of possibly conflicting with any other letsencrypt based utility on the same host
module "router" {
  source        = "./modules/router"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname
  user          = "root"

  networks      = {
    // (module.network.vlan): local.nuc.router_ip,
    "dubo-vlan": local.nuc.router_ip,
  }

  dns           = [
    // module.dns.ip,
    local.nuc.dns_ip,
  ]

  staging       = false
  domain        = var.domain
  email         = var.email

  username      = var.restricted_user
  password      = var.restricted_pwd
}
