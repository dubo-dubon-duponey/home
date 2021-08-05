module "dns-nig" {
  source        = "../modules/dns"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nig
  }
  hostname      = local.networks.nig.hostname
  networks      = {
    (local.networks.nig.vlan): local.services.reserved.dns_nig,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips
}

module "logger-nig" {
  source        = "../modules/logger"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nig
  }
  hostname      = local.networks.nig.hostname
  networks      = {
    (local.networks.nig.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nig,
  ]
  // This works only because ip are static
  // XXX this should really be replaced by either:
  // - mDNS enabled logger
  // - front caddy routing to services with dns registered domain name
  hosts         = {
    (module.elastic.domain): local.services.reserved.elastic, // module.elastic.network[0].ip_address, //  local.services.reserved.elastic,
    (module.kibana.domain): local.services.reserved.kibana // module.kibana.network[0].ip_address, // local.services.reserved.kibana,
  }

  user          = "root"
  log           = false
  log_level     = "warning"

  elastic       = "https://${module.elastic.domain}:${module.elastic.port}"
  elasticUser   = local.services.elastic.username
  elasticPassword = local.services.elastic.password

  kibana        = "https://${module.kibana.domain}:${module.kibana.port}"
  kibanaUser    = local.services.kibana.username
  kibanaPassword= local.services.kibana.password
}

module "sound-bedroom" {
  source        = "../modules/audio-receiver"
  registry      = local.registry.address

  providers     = {
    docker        = docker.nig
  }
  hostname      = local.networks.nig.hostname
  networks      = {
    (local.networks.nig.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nig,
  ]

  hw_index      = 0
  mixer_name    = "Digital"
  card_name     = "sndrpihifiberry"

  station       = local.services.sound.bedroom.audio_name
  volume        = local.services.sound.bedroom.volume
}

/*
hw_index      = 1
mixer_name    = "PCM"
card_name     = "DACE17,DEV=1"
volume        = 100
*/
