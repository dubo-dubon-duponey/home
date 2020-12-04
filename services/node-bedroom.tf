module "dns-nig" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.nig
  }

  hostname      = local.networks.nig.hostname

  networks      = {
    (local.networks.nig.vlan): local.services.dns_nig,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
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
    local.services.dns_nig,
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
    local.services.dns_nig,
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
