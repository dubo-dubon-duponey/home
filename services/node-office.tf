module "dns-nuc" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.nuc
  }

  hostname      = local.networks.nuc.hostname

  networks      = {
    (local.networks.nuc.vlan): local.services.dns_nuc,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}

module "logger-nuc" {
  source        = "../modules/logger"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  user          = "root"
  log           = false

  // XXX replace with mDNS name for elastic...
  elastic       = module.elastic.network[0].ip_address
  // XXX replace with mDNS name for kibana...
  kibana        = "https://${local.log.address}"
  kibanaUser    = local.log.username
  kibanaPassword= local.log.password
}

module "share" {
  source        = "../modules/share"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  user          = "root"

  users         = ["dmp"]
  passwords     = length(var.afp_password) != 0 ? [var.afp_password] : [random_string.afp_pwd.result]
  station       = var.afp_server_name

}
