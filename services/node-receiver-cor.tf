module "dns-cor" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.corpisone
  }

  hostname      = local.cor.hostname

  networks      = {
    (module.network-cor.vlan): local.cor.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "cor.dns.healthcheck.jsboot.space"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips

  registry      = local.registry.address
}

module "logger-cor" {
  source        = "./modules/system-logger"
  providers     = {
    docker        = docker.corpisone
  }

  hostname      = local.cor.hostname

  networks      = {
    (module.network-cor.vlan): "",
  }

  user          = "root"

  dns           = [
    module.dns-cor.ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = "https://${local.log.address}"
  kibanaUser    = local.log.username
  kibanaPassword= local.log.password

  registry      = local.registry.address
}

module "media-receiver-cor" {
  source        = "./modules/media-receiver"
  providers     = {
    docker  = docker.corpisone
  }

  hostname      = local.cor.hostname

  networks      = {
    (module.network-cor.vlan): "",
  }

  dns           = [
    module.dns-cor.ip,
  ]

  station       = local.cor.audio_name
  hw_index      = local.cor.hw_index
  mixer_name    = local.cor.mixer_name
  card_name     = local.cor.card_name
  volume        = local.cor.volume

  registry      = local.registry.address
}
