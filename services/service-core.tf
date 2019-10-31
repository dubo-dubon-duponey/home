module "core-nuc" {
  source              = "./modules/core"
  providers           = {
    docker  = docker.nucomedon
  }

  network           = module.network-nuc.vlan
  hostname          = "nucomedon.container"
  dns_upstream_name = var.dns_upstream_name
  dns_upstream_ips  = var.dns_upstream_ips
  elastic           = "${local.nuc_ip}:9200"
  kibana            = "${local.nuc_ip}:5601"
}

module "core-dac" {
  source              = "./modules/core"
  providers           = {
    docker  = docker.dacodac
  }

  network           = module.network-dac.vlan
  hostname          = "dacodac.container"
  dns_upstream_name = var.dns_upstream_name
  dns_upstream_ips  = var.dns_upstream_ips
  elastic           = "${local.nuc_ip}:9200"
  kibana            = "${local.nuc_ip}:5601"
}

module "core-nig" {
  source              = "./modules/core"
  providers           = {
    docker  = docker.nightingale
  }

  network           = module.network-nig.vlan
  hostname          = "nightingale.container"
  dns_upstream_name = var.dns_upstream_name
  dns_upstream_ips  = var.dns_upstream_ips
  elastic           = "${local.nuc_ip}:9200"
  kibana            = "${local.nuc_ip}:5601"
}
