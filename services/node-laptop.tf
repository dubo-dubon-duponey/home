// XXX the usefulness of this is unclear
/*
module "dns-mac" {
  source        = "../modules/dns"
  registry      = local.registry.address

  providers     = {
    docker        = docker.mac
  }
  hostname      = local.networks.mac.hostname
  networks      = {
    "bridge": "" // (local.networks.mac.vlan): "" // local.services.reserved.dns_mac,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips
}
*/

// XXX this one should point to the public endpoint of kibana / elastic, with authentication
// XXX this one can not work with /var/sys/log it seems
/*
module "logger-mac" {
  source        = "../modules/logger"
  providers     = {
    docker        = docker.mac
  }

  hostname      = local.networks.mac.hostname

  networks      = {
    (local.networks.mac.vlan): "",
  }

  user          = "root"

  dns           = [
    local.services.reserved.dns_mac,
  ]

  log           = false

  // XXX replace with mDNS name for elastic...
  elastic       = module.elastic.network[0].ip_address
  // XXX replace with mDNS name for kibana...
  kibana        = "https://${local.log.address}"
  kibanaUser    = local.log.username
  kibanaPassword= local.log.password

  registry      = local.registry.address
}
*/

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
    module.dns-mac.ip,
  ]

  staging       = true
  domain        = var.domain
  email         = var.email
  #  kibana        = module.elk.kibana
  auth_username = var.restricted_user
  auth_password = var.restricted_pwd
}
*/
