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

  // registry      = module.router.ip == "" ? "registry.dev.${module.router.domain}" : "registry.dev.${module.router.domain}"
}
*/

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
  healthcheck   = "mac.dns.healthcheck.jsboot.space"

  upstream_name = local.dns.upstream_name
  upstream_ips  = local.dns.upstream_ips

  registry      = local.registry.address
}


/*
module "router" {
  source        = "./modules/system-router"
  providers     = {
    docker  = docker.macarena
  }

  hostname      = local.mac.hostname
  // user          = "root"

  networks      = {
    "bridge": "",
  }

  dns           = [
    module.dns-mac.ip,
  ]

  staging       = true
  domain        = var.domain
  email         = var.email
  #  kibana        = module.elk.kibana
  username      = var.restricted_user
  password      = var.restricted_pwd
}
*/
