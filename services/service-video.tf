module "video-plex" {
  source        = "./modules/plex"
  providers     = {
    docker  = docker.nucomedon
  }

  nickname      = "plex"
  hostname      = local.nuc_hostname # XXX or bridge?
  log           = true
  # network       = module.network-nuc.vlan
  network       = module.network-nuc.bridge
  dns           = [module.dns-dac.ip]

  data_path     = "${var.volumes_root}/data/plex"
  movie_path    = "/home/big/The Very End/"

  login         = var.plex_login
  password      = var.plex_password
  public_ip     = var.public_ip
  email         = var.email
  station       = var.plex_server_name
}
