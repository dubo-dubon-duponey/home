module "dns-dac" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.dac
  }

  hostname      = local.networks.dac.hostname

  networks      = {
    (local.networks.dac.vlan): local.services.dns_dac,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}

module "logger-dac" {
  source        = "../modules/logger"
  registry      = local.registry.address

  providers     = {
    docker        = docker.dac
  }
  hostname      = local.networks.dac.hostname
  networks      = {
    (local.networks.dac.vlan): "",
  }
  dns           = [
    local.services.dns_dac,
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

module "sound-lounge" {
  source        = "../modules/audio-receiver"
  registry      = local.registry.address

  providers     = {
    docker        = docker.dac
  }
  hostname      = local.networks.dac.hostname
  networks      = {
    (local.networks.dac.vlan): "",
  }
  dns           = [
    local.services.dns_dac,
  ]

  station       = local.services.sound.lounge.audio_name
  volume        = local.services.sound.lounge.volume

  hw_index      = 1
  mixer_name    = "PCM"
  card_name     = "Qutest"
}
