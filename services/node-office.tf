module "dns-nuc" {
  source        = "../modules/dns"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): local.services.reserved.dns_nuc,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips
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
    local.services.reserved.dns_nuc,
  ]

  // XXX brittle as fuck - this works only because docker uses the same alias as the domain name for elastic and kibana, and they are on the same machine
  // Other nodes in the network have to leverage hosts declaration
  user          = "root"
  log           = false

  elastic       = "https://${module.elastic.domain}:${module.elastic.port}"
  elasticUser   = local.services.elastic.username
  elasticPassword = local.services.elastic.password

  kibana        = "https://${module.kibana.domain}:${module.kibana.port}"
  kibanaUser    = local.services.kibana.username
  kibanaPassword= local.services.kibana.password
}

module "share-netatalk" {
  source        = "../modules/share-netatalk"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  users         = ["dmp"]
  passwords     = length(var.afp_password) != 0 ? [var.afp_password] : [random_string.afp_pwd.result]
  station       = var.afp_server_name
}

module "share-samba" {
  source        = "../modules/share-samba"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  users         = ["dmp"]
  passwords     = length(var.afp_password) != 0 ? [var.afp_password] : [random_string.afp_pwd.result]
  mdns_name     = "Só danço samba"
  mdns_host     = "samba"
}
