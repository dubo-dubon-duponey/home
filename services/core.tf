###########################
# Core - base infrastructure needed for everything else to work
###########################

# Log infrastructure

module "elastic" {
  source = "../modules/elastic"
  registry      = local.registry.address

  providers = {
    docker = docker.nuc
  }
  hostname  = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): local.services.reserved.elastic,
  }
  dns           = [
#    local.services.reserved.dns_nuc,
  ]

  # user          = "root"

  # Kibana does not have mDNS resolution capabilities - it also does not allow for SNI
  # Hence, we need the nickname to match the domain name, instead of default shenanigans
  mdns_host     = "elastic"
  domain        = "elastic.local"

  nickname      = "elastic.local"
  auth_username = local.services.elastic.username
  auth_password = local.services.elastic.bcrypt
  mdns_name     = "Elastic"
  cert_path     = "${var.volumes_root}/certs/dubo"

  data_path     = "${var.volumes_root}/data/elastic"
  log           = false
  port          = 4242
}

module "kibana" {
  source = "../modules/kibana"
  registry      = local.registry.address

  providers = {
    docker = docker.nuc
  }
  hostname  = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): local.services.reserved.kibana,
  }
  dns           = [
#    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  # Filebeat needs to talk to kibana to load dashboards - kind of ridiculous, but here it is
  # In our context, filebeat is not yet mDNS capable...
  # Short term for the nuc testing, we can get away with tweaking the docker nodename to match the TLS domain
  # This will not work on other hosts though
  mdns_host     = "kibana"
  domain        = "kibana.local"

  nickname      = "kibana.local"
  auth_username = local.services.kibana.username
  auth_password = local.services.kibana.bcrypt
  mdns_name     = "Kibana"
  cert_path     = "${var.volumes_root}/certs/registry"

  data_path     = "${var.volumes_root}/data/kibana"
  log           = false

  elastic_container = "https://${module.elastic.domain}:${module.elastic.port}"
  elastic_username = local.services.elastic.username
  elastic_password = local.services.elastic.password
}

# Add prometheus

