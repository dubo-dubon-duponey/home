provider "docker" {
  version = "= 2.7.2"
  // XXXtmp
  // host = "ssh://${local.node.user}@${local.node.ip}"
  alias = "node"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

module "network" {
  source    = "../modules/network"
  providers = {
    docker  = docker.node
  }

  driver    = local.node.driver
  range     = local.node.range
  interface = local.node.iface
  subnet    = local.subnet
  gateway   = local.gateway
}

###########################
# Core - base infrastructure needed for everything else to work
###########################

# First, a working DNS server - every other system on the nuc depends on this
module "dns" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.node
  }

  hostname      = local.node.hostname

  networks      = {
    (module.network.vlan): local.node.dns_ip,
    (module.network.bridge): "",
    // XXXtmp does not work as expected?
    // "host": "",
  }

  user          = "root"
  # XXX bridged dns? IIRC some docker fuckerism over UDP
  expose        = true
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
  #image         = "${local.registry.address}/dubo-dubon-duponey/coredns:latest"
  # image = "ghcr.io/dubo-dubon-duponey/coredns:latest"
}

# Then, a local registry, hopefully pre-populated with every required image
module "registry" {
  source        = "../modules/registry"
  providers     = {
    docker  = docker.node
  }

  hostname      = local.node.hostname

  networks      = {
    (module.network.vlan): "",
  }

  dns           = [
    module.dns.ip,
  ]

  username      = local.services.registry.username
  password      = local.services.registry.password

  data_path     = "${var.volumes_root}/data/registry"

  registry      = local.registry.address
  #image         = "${local.registry.address}/dubo-dubon-duponey/registry:latest"
  # image = "dubodubonduponey/registry:latest"
}
