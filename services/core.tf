###########################
# Core - base infrastructure needed for everything else to work
###########################

# Log infrastructure

module "elastic" {
  source = "../modules/elastic"
  providers = {
    docker = docker.nuc
  }

  hostname  = local.networks.nuc.hostname
  log       = false
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  registry      = local.registry.address
}

module "kibana" {
  source = "../modules/kibana"
  providers = {
    docker = docker.nuc
  }

  hostname  = local.networks.nuc.hostname
  log       = false
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.dns_nuc,
  ]

  elastic_container = "http://${module.elastic.name}:9200"

  registry      = local.registry.address
}

# Add prometheus

