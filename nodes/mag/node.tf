module "network" {
  source      = "../../modules/network"
  providers   = {
    docker    = docker.node
  }

  prefix      = "dubo"
  driver      = local.networks.driver
  range       = local.networks.range
  interface   = local.networks.iface
  aux_address = local.networks.aux
  subnet      = local.networks.subnet
  gateway     = local.networks.gateway
}

/*
module "dns-lan" {
  source        = "../../modules/dns"
  registry      = local.registry.address

  providers     = {
    docker        = docker.node
  }
  hostname      = local.networks.hostname
  nickname      = "dns-lan"

  networks      = {
    (module.network.vlan): local.services.reserved.dns_lan,
  }

  log_level     = "warn"
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips
}
*/

module "dns" {
  source        = "../../modules/dns"
  registry      = local.registry.address

  providers     = {
    docker        = docker.node
  }
  hostname      = local.networks.hostname
  networks      = {
    (module.network.vlan): local.services.reserved.dns,
  }

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips
}
/*
module "logger" {
  source        = "../../modules/logger"
  registry      = local.registry.address

  providers     = {
    docker        = docker.node
  }
  hostname      = local.networks.hostname
  networks      = {
    (module.network.vlan): "",
  }
  dns           = [
    local.services.reserved.dns,
  ]

  user          = "root"
  log           = false
  log_level     = "warn"
  mdns_nss      = local.services.mdns_nss

  elastic       = "https://${local.services.elastic.domain}:${local.services.elastic.port}"
  elasticUser   = local.services.elastic.username
  elasticPassword = local.services.elastic.password

  kibana        = "https://${local.services.kibana.domain}:${local.services.kibana.port}"
  kibanaUser    = local.services.kibana.username
  kibanaPassword= local.services.kibana.password
}
*/

module "sound" {
  source        = "../../modules/audio-receiver"
  registry      = local.registry.address

  providers     = {
    docker        = docker.node
  }
  hostname      = local.networks.hostname
  networks      = {
    (module.network.vlan): "",
  }
  dns           = [
    local.services.reserved.dns,
  ]

  log_level     = "warn" // info

  station       = local.services.sound.audio_name
  volume        = local.services.sound.volume
  device        = local.services.sound.device
  mixer_name    = local.services.sound.mixer
  master        = local.services.sound.master
  mdns_nss      = local.services.mdns_nss
}
