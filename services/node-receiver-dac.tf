module "dns-dac" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.dacodac
  }

  hostname      = local.dac.hostname

  networks      = {
    (module.network-dac.vlan): local.dac.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "dac.dns.healthcheck.jsboot.space"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips

  registry      = local.registry.address
}

module "logger-dac" {
  source        = "./modules/system-logger"
  providers     = {
    docker        = docker.dacodac
  }

  hostname      = local.dac.hostname

  networks      = {
    (module.network-dac.vlan): "",
  }

  user          = "root"

  dns           = [
    module.dns-dac.ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip

  registry      = local.registry.address
}

module "media-receiver-dac" {
  source        = "./modules/media-receiver"
  providers     = {
    docker  = docker.dacodac
  }

  hostname      = local.dac.hostname

  networks      = {
    (module.network-dac.vlan): "",
  }

  dns           = [
    module.dns-dac.ip,
  ]

  station       = local.dac.audio_name
  hw_index      = local.dac.hw_index
  mixer_name    = local.dac.mixer_name
  card_name     = local.dac.card_name
  volume        = local.dac.volume

  registry      = local.registry.address
}
