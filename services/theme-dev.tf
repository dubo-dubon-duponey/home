# Write registry
# Then, a local registry, hopefully pre-populated with every required image
module "registry" {
  source        = "../modules/registry"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = []

  // user          = "root"

  nickname      = "push-registry"
  data_path     = "${var.volumes_root}/data/registry"
  cert_path     = "${var.volumes_root}/certs/registry"
  username      = local.services.registry.username
  password      = local.services.registry.password
  domain        = "push-registry.local"
  push          = "authenticated"
  pull          = "authenticated"
}

module "apt-mirror" {
  source        = "../modules/apt-mirror"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  data_path     = "${var.volumes_root}/data/apt-mirror"
  tmp_path     = "${var.volumes_root}/tmp/apt-mirror"
  username      = local.services.apt.username
  password      = local.services.apt.password
}

module "apt-cache" {
  source        = "../modules/apt-cache"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  data_path     = "${var.volumes_root}/data/apt-cache"
  username      = local.services.apt.username
  password      = local.services.apt.password
}

module "go" {
  source        = "../modules/go-proxy"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

}

# XXX annoyingly, this service cannot serve anything on macvlan on this same host
# One solution would be to serve these from dacodac instead
# Another would be to serve on host (assuming that even works)
# All this also begs the question of possibly conflicting with any other letsencrypt based utility on the same host
/*
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
*/

# Rethink the router

/*
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
*/
