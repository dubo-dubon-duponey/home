###########################
# Core - base infrastructure needed for everything else to work
###########################

# Then, a local registry, hopefully prepopulated with every required image
module "registry" {
  source        = "./modules/dev-registry"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  data_path     = "${var.volumes_root}/data/registry"
}

# First, a working DNS server - every other system on the nuc depends on this
module "dns-nuc" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): local.nuc.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "nuc.dns.healthcheck.jsboot.space"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips

  # registry      = module.registry.name
}

# XXX annoyingly, this service cannot serve anything on macvlan on this same host
# One solution would be to serve these from dacodac instead
# Another would be to serve on host (assuming that even works)
# All this also begs the question of possibly conflicting with any other letsencrypt based utility on the same host
module "router" {
  source        = "./modules/system-router"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname
  user          = "root"

  networks      = {
    (module.network-nuc.vlan): local.nuc.router_ip,
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  staging       = false
  domain        = var.domain
  email         = var.email

  username      = var.restricted_user
  password      = var.restricted_pwd

  # Just to force the dependency on the registry
  # This doesn't solve the problem - images are being checked before anything else and do not depend on the availability of any service
  # depends       = [module.registry.ip]
}

# Log infrastructure
module "elk" {
  source        = "./modules/system-elk"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  expose        = false

  dns           = [
    module.dns-nuc.ip,
  ]

  # Brutally debilitated attempt at forcing deployment order onto terraform
  # force_dependency = module.router.ip

  registry      = local.registry.address
}
