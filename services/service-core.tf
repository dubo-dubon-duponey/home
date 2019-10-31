module "dns-nuc" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.nucomedon
  }

  network       = module.network-nuc.vlan
  hostname      = local.nuc_hostname
  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips
}

module "dns-dac" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.dacodac
  }

  network       = module.network-dac.vlan
  hostname      = local.dac_hostname
  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips
}

module "dns-nig" {
  source        = "./modules/dns"
  providers     = {
    docker  = docker.nightingale
  }

  network       = module.network-nig.vlan
  hostname      = local.nig_hostname
  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips
}

module "logger-nuc" {
  source        = "./modules/logger"
  providers     = {
    docker        = docker.nucomedon
  }

  network       = module.network-nuc.vlan
  hostname      = local.nuc_hostname
  dns           = [module.dns-nuc.ip]

  elastic       = "${docker_container.logs-central.ip_address}:9200"
  kibana        = "${docker_container.logs-central.ip_address}:5601"
}

module "logger-dac" {
  source        = "./modules/logger"
  providers     = {
    docker        = docker.dacodac
  }

  network       = module.network-dac.vlan
  hostname      = local.dac_hostname
  dns           = [module.dns-dac.ip]

  elastic       = "${docker_container.logs-central.ip_address}:9200"
  kibana        = "${docker_container.logs-central.ip_address}:5601"
}

module "logger-nig" {
  source        = "./modules/logger"
  providers     = {
    docker        = docker.nightingale
  }

  network       = module.network-nig.vlan
  hostname      = local.nig_hostname
  dns           = [module.dns-nig.ip]

  elastic       = "${docker_container.logs-central.ip_address}:9200"
  kibana        = "${docker_container.logs-central.ip_address}:5601"
}








####################################################
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
