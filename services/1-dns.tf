###########################
# Lan-wide DNS
###########################

module "dns-dac" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.dacodac
  }

  hostname      = local.dac.hostname

  networks      = {
    (module.network-dac.vlan): local.dac.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "dns.farcloser.world"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips
}

module "dns-nuc" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): local.nuc.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "dns.farcloser.world"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips
}

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
  healthcheck   = "dns.farcloser.world"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips
}

module "dns-nig" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.nightingale
  }

  hostname      = local.nig.hostname

  networks      = {
    (module.network-nig.vlan): local.nig.dns_ip,
  }

  user          = "root"
  expose        = false
  healthcheck   = "dns.farcloser.world"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips
}

module "dns-mac" {
  source        = "./modules/root-dns"
  providers     = {
    docker        = docker.macarena
  }

  hostname      = local.mac.hostname

  networks      = {
    "bridge": "",
  }

  // user          = "root"
  expose        = true
  healthcheck   = "dns.farcloser.world"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips
}
