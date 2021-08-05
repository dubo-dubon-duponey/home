module "lounge_node" {
  source                    = "./sound-receiver"

  volumes_root              = var.volumes_root

  registry_address          = var.registry_address
  registry_username         = var.registry_username
  registry_password         = var.registry_password

  service_dns_upstream_name = var.service_dns_upstream_name
  service_dns_upstream_ips  = var.service_dns_upstream_ips

  name                      = var.lounge_name
}

/*
module "dns-dac" {
  source        = "../modules/dns"
  registry      = local.registry.address

  providers     = {
    docker        = docker.dac
  }
  hostname      = local.networks.dac.hostname
  networks      = {
    (local.networks.dac.vlan): local.services.reserved.dns_dac,
  }

  user          = "root"

  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips
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
    local.services.reserved.dns_dac,
  ]
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
    local.services.reserved.dns_dac,
  ]

  station       = local.services.sound.lounge.audio_name
  volume        = local.services.sound.lounge.volume

  hw_index      = 1
  mixer_name    = "PCM"
  card_name     = "Qutest"
}
*/
