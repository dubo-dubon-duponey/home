module "dns-nig" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.nightingale
  }

  hostname      = local.nig.hostname

  networks      = {
    (module.network-nig.vlan): local.nig.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "nig.dns.healthcheck.jsboot.space"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips

  registry      = local.registry.address
}

module "logger-nig" {
  source        = "./modules/system-logger"
  providers     = {
    docker        = docker.nightingale
  }

  hostname      = local.nig.hostname

  networks      = {
    (module.network-nig.vlan): "",
  }

  user          = "root"

  dns           = [
    module.dns-nig.ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip

  registry      = local.registry.address
}

module "media-receiver-nig" {
  source        = "./modules/media-receiver"
  providers     = {
    docker  = docker.nightingale
  }

  hostname      = local.nig.hostname

  networks      = {
    (module.network-nig.vlan): "",
  }

  dns           = [
    module.dns-nig.ip,
  ]

  station       = local.nig.audio_name
  hw_index      = local.nig.hw_index
  mixer_name    = local.nig.mixer_name
  card_name     = local.nig.card_name
  volume        = local.nig.volume

  registry      = local.registry.address
}
