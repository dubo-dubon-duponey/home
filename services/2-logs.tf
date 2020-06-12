module "elk" {
  source        = "./modules/system-elk"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  expose        = false

  dns           = [
    local.nuc.dns_ip,
  ]
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
    local.cor.dns_ip,
    local.nig.dns_ip,
    local.dac.dns_ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip
}

module "logger-nuc" {
  source        = "./modules/system-logger"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  user          = "root"

  dns           = [
    local.nuc.dns_ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip
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
    local.dac.dns_ip,
    local.cor.dns_ip,
    local.nig.dns_ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip
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
    local.nig.dns_ip,
    local.dac.dns_ip,
    local.cor.dns_ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip
}

/*
// XXX this one should point to the public endpoint of kibana / elastic, with authentication
module "logger-mac" {
  source        = "./modules/system-logger"
  providers     = {
    docker        = docker.macarena
  }

  hostname      = local.mac.hostname

  networks      = {
    "bridge": "",
  }

  user          = "root"

  dns           = [
    "127.0.0.1",
  ]

  log           = false

  // Docker for mac does not have the default system mounts
  mounts        =   []

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip
}
*/
