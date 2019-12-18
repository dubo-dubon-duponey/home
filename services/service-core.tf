###########################
# DNS
###########################
module "dns-nuc" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.nucomedon
  }

  nickname      = "dns-con"
  hostname      = local.nuc_hostname
  privileged    = true
  log           = true
  network       = module.network-nuc.vlan

  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips
}

module "dns-dac" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.dacodac
  }

  nickname      = "dns-con"
  hostname      = local.nuc_hostname
  privileged    = true
  log           = true
  network       = module.network-nuc.vlan

  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips
}

/*
module "dns-nig" {
  source        = "./modules/dns"
  providers     = {
    docker  = docker.nightingale
  }

  nickname      = "dns-con"
  hostname      = local.nuc_hostname
  privileged    = true
  network       = module.network-nuc.vlan
  log           = true

  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips
}
*/

###########################
# Logger
###########################
module "logger-nuc" {
  source        = "./modules/logger"
  providers     = {
    docker        = docker.nucomedon
  }

  nickname      = "logger"
  hostname      = local.nuc_hostname
  privileged    = true
  log           = false
  network       = module.network-nuc.vlan
  dns           = [module.dns-nuc.ip]

  elastic       = module.elk.elastic
  kibana        = module.elk.kibana
}

module "logger-dac" {
  source        = "./modules/logger"
  providers     = {
    docker        = docker.dacodac
  }

  nickname      = "logger"
  hostname      = local.dac_hostname
  privileged    = true
  log           = false
  network       = module.network-dac.vlan
  dns           = [module.dns-dac.ip]

  elastic       = module.elk.elastic
  kibana        = module.elk.kibana
}
/*
module "logger-nig" {
  source        = "./modules/logger"
  providers     = {
    docker        = docker.nightingale
  }

  nickname      = "logger"
  hostname      = local.nig_hostname
  privileged    = true
  network       = module.network-nig.vlan
  log           = true
  dns           = [module.dns-nig.ip]

  elastic       = module.elk.elastic
  kibana        = module.elk.kibana
#  elastic       = "${docker_container.logs-central.ip_address}:9200"
#  kibana        = "${docker_container.logs-central.ip_address}:5601"
}
*/

###########################
# ELK
###########################
module "elk" {
  source        = "./modules/elk"
  providers     = {
    docker        = docker.nucomedon
  }

  # nickname      = "logger"
  hostname      = local.nuc_hostname
  privileged    = false
  log           = true
  network       = module.network-nuc.vlan
  dns           = [module.dns-nuc.ip]
}


####################################################
/*
data "docker_registry_image" "logs-central" {
  name = "sebp/elk:740"
}

resource "docker_image" "logs-central" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.logs-central.name
  pull_triggers = [data.docker_registry_image.logs-central.sha256_digest]
}

resource "docker_container" "logs-central" {
  provider      = docker.nucomedon
  name          = "logs-central"
  image         = docker_image.logs-central.latest

  restart       = "always"

  network_mode  = module.network-nuc.vlan

  env = [
    "DOMAIN=",
  ]

  labels = {
    "co.elastic.logs/enabled": false,
  }
}
*/
