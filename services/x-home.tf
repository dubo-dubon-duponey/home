module "share" {
  source        = "./modules/share"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname
  user          = "root"

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    local.nuc.dns_ip,
  ]

  users         = ["dmp"]
  passwords     = length(var.afp_password) != 0 ? [var.afp_password] : [random_string.afp_pwd.result]
  station       = var.afp_server_name
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
    local.nuc.dns_ip,
  ]

  staging       = false
  domain        = var.domain
  email         = var.email
  #  kibana        = module.elk.kibana
  username      = var.restricted_user
  password      = var.restricted_pwd
}

/*
module "router" {
  source        = "./modules/system-router"
  providers     = {
    docker  = docker.macarena
  }

  hostname      = local.mac.hostname
  // user          = "root"

  networks      = {
    "bridge": "",
  }

  dns           = [
    local.mac.dns_ip,
  ]

  staging       = true
  domain        = var.domain
  email         = var.email
  #  kibana        = module.elk.kibana
  username      = var.restricted_user
  password      = var.restricted_pwd
}
*/
