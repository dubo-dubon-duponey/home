module "share" {
  source        = "./modules/share"
  providers     = {
    docker        = docker.nucomedon
  }

  nickname      = "share"
  hostname      = local.nuc_hostname
  privileged    = true
  log           = true
  network       = module.network-nuc.vlan
  dns           = [module.dns-nuc.ip]

  users         = ["dmp"]
  passwords     = [random_string.afp_pwd.result]
  station       = var.afp_server_name
}

# XXX annoyingly, this service cannot serve anything on macvlan on this same host
# One solution would be to serve these from dacodac instead
# Another would be to serve on host (assuming that even works)
# All this also begs the question of possibly conflicting with any other letsencrypt based utility on the same host
module "router" {
  source        = "./modules/router"
  providers     = {
    docker        = docker.dacodac
  }

  nickname      = "router"
  hostname      = local.dac_hostname
  log           = true
  network       = module.network-nuc.bridge
  dns           = [
#    local.dac_ip,
    local.nuc_ip,
  ]

  domain        = "home.farcloser.world"
  email         = "o@farcloser.world"
  staging       = false
  kibana        = module.elk.kibana
  username      = var.restricted_user
  password      = var.restricted_pwd
}
