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
    (local.networks.vlan): "",
  }
  dns           = [
    local.services.reserved.dns,
  ]
  // This works only because ip are static
  // XXX this should really be replaced by either:
  // - mDNS enabled logger
  // - front caddy routing to services with dns registered domain name
  // XXX Looks like we can drop the ip sometimes???
  hosts         = {
    (local.services.elastic.domain): local.services.reserved.elastic, // module.elastic.network[0].ip_address, //  local.services.reserved.elastic,
    (local.services.kibana.domain): local.services.reserved.kibana // module.kibana.network[0].ip_address, // local.services.reserved.kibana,
  }

  user          = "root"
  log           = false
  log_level     = "warn"

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

  // hw_index      = 1
  // mixer_name    = "PCM"
  // XXX purely experimental for now and unique to this node
  display_enabled = true
  spotify_id = "72349aed826c4f419038414ccb261b2f"
  spotify_secret = "d49c72f4fa08483cbbe26abd585c2ab5"
}

