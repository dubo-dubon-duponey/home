/**
 * This is meant to bring-up DNS servers to be used by the lan (NOT by containers)
 * As such, they need static ips, and also to be accessible from the hosts themselves (see below).
 * This also brings-up a read-only registry, with a self-signed cert, broadcasting over mDNS.
 * This registry is from where any subsequent image is to be retrieved
 */
# To be able to access it from the host though, an additional vlan network is required on the host
/*
ip link add local-shim link eno1 type macvlan mode bridge
ip addr add 10.0.4.41/24 dev local-shim
ip link set mynet-shim up
ip route add 10.0.4.40/31 dev local-shim
*/

provider "docker" {
  version = "= 2.8.0"
  host = "ssh://${local.providers.nuc.user}@${local.providers.nuc.host}"
  alias = "nuc"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.8.0"
  host = "ssh://${local.providers.nig.user}@${local.providers.nig.host}"
  alias = "nig"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.8.0"
  host = "ssh://${local.providers.dac.user}@${local.providers.dac.host}"
  alias = "dac"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.8.0"
  alias = "mac"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

// XXXtmp dead
/*
provider "docker" {
  version = "= 2.8.0"
host = "ssh://${local.providers.cor.user}@${local.providers.cor.host}"
  alias = "cor"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}
*/

module "network-nuc" {
  source    = "../modules/network"
  providers = {
    docker  = docker.nuc
  }

  prefix    = "dubo-"
  driver    = local.networks.nuc.driver
  range     = local.networks.nuc.range
  interface = local.networks.nuc.iface
  aux_address = local.networks.nuc.aux
  subnet    = local.subnet
  gateway   = local.gateway
}

module "network-nig" {
  source      = "../modules/network"
  providers   = {
    docker    = docker.nig
  }

  prefix      = "dubo-"
  driver      = local.networks.nig.driver
  range       = local.networks.nig.range
  interface   = local.networks.nig.iface
  aux_address = local.networks.nig.aux
  subnet      = local.subnet
  gateway     = local.gateway
}

// XXXtmp preserve for now
/*
module "network-dac" {
  source      = "../modules/network"
  providers   = {
    docker    = docker.dac
  }

  prefix      = "dubo-"
  driver      = local.networks.dac.driver
  range       = local.networks.dac.range
  interface   = local.networks.dac.iface
  aux_address = local.networks.dac.aux
  subnet      = local.subnet
  gateway     = local.gateway
}
*/

module "network-mac" {
  source      = "../modules/network"
  providers   = {
    docker    = docker.mac
  }

  prefix      = "dubo-"
  driver      = local.networks.mac.driver
  range       = local.networks.mac.range
  interface   = local.networks.mac.iface
  aux_address = local.networks.mac.aux
  subnet      = local.subnet
  gateway     = local.gateway
}


// XXXtmp dead
/*
module "network-cor" {
  source      = "../modules/network"
  providers   = {
    docker    = docker.cor
  }

  prefix      = "dubo-"
  driver      = local.networks.cor.driver
  range       = local.networks.cor.range
  interface   = local.networks.cor.iface
  aux_address = local.networks.cor.aux
  subnet      = local.subnet
  gateway     = local.gateway
}
*/


###########################
# Core - base infrastructure needed for everything else to work
###########################

# First, a working DNS server - every other system on the nuc depends on this
module "dns-lan-1" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.nuc
  }

  hostname      = local.networks.nuc.hostname
  nickname      = "dns-lan"

  networks      = {
    (module.network-nuc.vlan): local.services.dns1,
    // XXX does not work at this point: https://github.com/moby/libnetwork/issues/1729 and fix here: https://github.com/moby/libnetwork/pull/2577
    (module.network-nuc.bridge): "",
  }

  user          = "root"
  # XXX bridged dns? IIRC some docker fuckerism over UDP
  expose        = true
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}

module "dns-lan-2" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.nig
  }

  hostname      = local.networks.nig.hostname
  nickname      = "dns-lan"

  networks      = {
    (module.network-nig.vlan): local.services.dns2,
    // XXX does not work at this point: https://github.com/moby/libnetwork/issues/1729 and fix here: https://github.com/moby/libnetwork/pull/2577
    (module.network-nig.bridge): "",
  }

  user          = "root"
  # bridged dns? IIRC some docker fuckerism over UDP
  expose        = true
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}

// XXXtmp
/*
module "dns-lan-3" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.dac
  }

  hostname      = local.networks.dac.hostname
  nickname      = "dns-lan"

  networks      = {
    (module.network-dac.vlan): local.services.dns3,
    // XXX does not work at this point: https://github.com/moby/libnetwork/issues/1729 and fix here: https://github.com/moby/libnetwork/pull/2577
    (module.network-dac.bridge): "",
  }

  user          = "root"
  # bridged dns? IIRC some docker fuckerism over UDP
  expose        = true
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}

module "dns-lan-4" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.cor
  }

  hostname      = local.networks.cor.hostname
  nickname      = "dns-lan"

  networks      = {
    (module.network-cor.vlan): local.services.dns4,
    // XXX does not work at this point: https://github.com/moby/libnetwork/issues/1729 and fix here: https://github.com/moby/libnetwork/pull/2577
    (module.network-cor.bridge): "",
  }

  user          = "root"
  # bridged dns? IIRC some docker fuckerism over UDP
  expose        = true
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}
*/

module "dns-mac" {
  source        = "../modules/dns"
  providers     = {
    docker        = docker.mac
  }

  hostname      = local.networks.mac.hostname
  nickname      = "dns-lan"

  networks      = {
    (module.network-mac.vlan): "",
    // XXX does not work at this point: https://github.com/moby/libnetwork/issues/1729 and fix here: https://github.com/moby/libnetwork/pull/2577
    (module.network-mac.bridge): "",
  }

  user          = "root"
  # bridged dns? IIRC some docker fuckerism over UDP
  expose        = true
  healthcheck   = local.services.dns.healthcheck

  upstream_name = local.services.dns.upstream_name
  upstream_ips  = local.services.dns.upstream_ips

  registry      = local.registry.address
}

# Then, a local registry, hopefully pre-populated with every required image
module "registry" {
  source        = "../modules/registry"
  providers     = {
    docker  = docker.nuc
  }

  hostname      = local.networks.nuc.hostname

  // user          = "root"

  networks      = {
    // XXXtmp
    (module.network-nuc.vlan): "",
  }

  # XXX this simply is not usable
  # module.dns.network[0].ip_address,
  dns           = [
/*    local.services.dns1,
    local.services.dns2,
    local.services.dns3,
    local.services.dns4,*/
  ]

  username      = local.services.registry.username
  password      = local.services.registry.password

  data_path     = "${var.volumes_root}/data/registry"
  cert_path     = "${var.volumes_root}/certs/registry"

  registry      = local.registry.address
}
