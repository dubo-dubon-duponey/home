module "logger-nuc" {
  source        = "./modules/system-logger"
  providers     = {
    docker        = docker.nucomedon
  }

  #  xxx_force_depends_terraform = "registry.dev.${module.router.domain}"

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  user          = "root"

  dns           = [
    module.dns-nuc.ip,
  ]

  log           = false

  elastic       = module.elk.elastic_ip
  kibana        = module.elk.kibana_ip

  # Ugly as fuck and counter intuitive, but we want to depend on the router availability
  // registry      = module.router.ip == "" ? "registry.dev.${module.router.domain}" : "registry.dev.${module.router.domain}"
  registry      = local.registry.address
}

module "apt" {
  source        = "./modules/dev-apt"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  // registry      = module.router.ip == "" ? "registry.dev.${module.router.domain}" : "registry.dev.${module.router.domain}"
  registry      = local.registry.address
}

module "go" {
  source        = "./modules/dev-go"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  registry      = local.registry.address
}

module "share" {
  source        = "./modules/share"
  providers     = {
    docker        = docker.nucomedon
  }

  hostname      = local.nuc.hostname
  user          = "root"

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  users         = ["dmp"]
  passwords     = length(var.afp_password) != 0 ? [var.afp_password] : [random_string.afp_pwd.result]
  station       = var.afp_server_name

  registry      = local.registry.address
}



###########################
# Roon server
###########################
module "media-server-roon" {
  source        = "./modules/media-roon"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  data_path     = "${var.volumes_root}/data/roon"
  music_path    = "/home/data/audio"

  registry      = local.registry.address
}

###########################
# Plex server
###########################
module "media-server-plex" {
  source        = "./modules/media-plex"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  # network       = module.network-nuc.vlan
  networks      = {
    (module.network-nuc.vlan): "", # XXX ideally bridge, to better control networking, but...
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  data_path     = "${var.volumes_root}/data/plex"
  movie_path    = "/home/big/Future/"

  login         = var.plex_login
  password      = var.plex_password
  public_ip     = var.public_ip
  email         = var.email
  station       = var.plex_server_name

  registry      = local.registry.address
}


module "wiz" {
  source        = "./modules/media-wiz"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname

  networks      = {
    (module.network-nuc.vlan): "",
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  station       = "Whiz Bang "

  registry      = local.registry.address
}

