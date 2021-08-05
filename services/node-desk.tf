/*
module "dns-cor" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.cor
  }

  hostname      = local.networks.cor.hostname

  networks      = {
    (local.networks.cor.vlan): local.services.reserved.dns_cor,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}
*/

/*

module "logger-cor" {
  source        = "../modules/logger"
  providers     = {
    docker        = docker.cor
  }

  hostname      = local.networks.cor.hostname

  networks      = {
    (local.networks.cor.vlan): "",
  }

  user          = "root"

  dns           = [
    local.services.reserved.dns_cor,
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

module "sound-lounge" {
  source        = "../modules/audio-receiver"
  registry      = local.registry.address

  providers     = {
    docker  = docker.cor
  }
  hostname      = local.networks.cor.hostname
  networks      = {
    (local.networks.cor.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_cor,
  ]

  station       = local.services.sound.lounge.audio_name
  volume        = local.services.sound.lounge.volume

  hw_index      = 1
  mixer_name    = "PCM"
  card_name     = "Mojo"
}

*/
