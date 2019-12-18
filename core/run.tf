###########################
# Lan-wide DNS
###########################
module "lan-dns-nuc" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.nucomedon
  }

  nickname      = "dns-lan"
  hostname      = local.nuc_hostname
  log           = true
  network       = "bridge"

  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips

  image         = "dubodubonduponey/coredns:v1-private-copy"
}

module "lan-dns-dac" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.dacodac
  }

  nickname      = "dns-lan"
  hostname      = local.dac_hostname
  log           = true
  network       = "bridge"

  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips

  image         = "dubodubonduponey/coredns:v1-private-copy"
}

/*
module "lan-dns-nig" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.nightingale
  }

  network       = "bridge"
  nickname      = "dns-lan"
  hostname      = local.nig_hostname
  upstream_name = local.dns_upstream_name
  upstream_ips  = local.dns_upstream_ips
  image         = "dubodubonduponey/coredns:v1-private-copy"
}
*/

module "lan-dns-mac" {
  source        = "./modules/dns"
  providers     = {
    docker        = docker.macarella
  }

  nickname      = "dns-lan"
  hostname      = local.mac_hostname
  log           = true
  network       = "bridge"

  upstream_name = var.dns_upstream_name
  upstream_ips  = var.dns_upstream_ips

  image         = "dubodubonduponey/coredns:v1-private-copy"
}
