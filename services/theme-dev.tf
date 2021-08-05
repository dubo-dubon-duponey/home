# Write registry
# Shares storage with the read-only endpoint
module "registry" {
  source        = "../modules/registry"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = []

  user          = "root"

  log_level     = "info"

  nickname      = "push-registry"
  auth_username = local.services.registry.username
  auth_password = local.services.registry.bcrypt
  mdns_name     = "Internal write registry"

  push          = "authenticated"
  pull          = "authenticated"

  // XXX enable
  // tls_mtls_mode = "require_and_verify"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/registry"
}

module "cache_registry" {
  source        = "../modules/registry"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = []

  user          = "root"

  log_level     = "info"

  nickname      = "cache-registry"
  // XXX replace with separate credentials
  auth_username = local.services.registry.username
  auth_password = local.services.registry.bcrypt
  mdns_name     = "Internal cache registry"

  push          = "authenticated"
  pull          = "authenticated"

  // XXX enable
  // tls_mtls_mode = "require_and_verify"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/registry_cache"
}

module "apt-mirror" {
  source        = "../modules/apt-mirror"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  log_level     = "info"

  nickname      = "apt-mirror"
  auth_username = local.services.apt.username
  auth_password = local.services.apt.bcrypt
  mdns_name     = "Apt mirror"

  tls_mtls_mode = "require_and_verify"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/apt-mirror"
}

module "apt-proxy" {
  source        = "../modules/apt-cache"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  log_level     = "info"

  nickname      = "apt-proxy"
  auth_username = local.services.apt.username
  auth_password = local.services.apt.bcrypt
  mdns_name     = "Apt proxy cache"
  additional_domains = "https://*.debian.org"
  is_proxy      = true

  # Want http redirects, and do not require certificates since proxy does not allow for that
  tls_auto       = "ignore_loaded_certs"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/apt-cache"
}

module "apt-front" {
  source        = "../modules/apt-cache"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  log_level     = "info"

  nickname      = "apt-front"
  auth_username = local.services.apt.username
  auth_password = local.services.apt.bcrypt
  mdns_name     = "Apt front cache"
  additional_domains = "https://*.debian.org"

  tls_mtls_mode = "require_and_verify"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/apt-front"
}

module "go" {
  source        = "../modules/go-proxy"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  log_level     = "info"

  nickname      = "go"
  auth_username = local.services.go.username
  auth_password = local.services.go.bcrypt
  mdns_name     = "Go proxy"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/go"
}

module "git" {
  source        = "../modules/git-proxy"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"

  log_level     = "info"

  nickname      = "git"
  auth_username = local.services.go.username
  auth_password = local.services.go.bcrypt
  mdns_name     = "Git proxy"

  // XXX enable
  // tls_mtls_mode = "require_and_verify"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/git"
}

module "buildkit" {
  source        = "../modules/buildkit"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): "",
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"
  log           = false

  log_level     = "info"

  nickname      = "buildkit"
  auth_username = local.services.buildkit.username
  auth_password = local.services.buildkit.bcrypt
  mdns_name     = "Buildkit daemon"

  // XXX enable - and honor that in the buildkit entrypoint
  // tls_mtls_mode = "require_and_verify"

  cert_path     = "${var.volumes_root}/certs/registry"
  data_path     = "${var.volumes_root}/data/buildkit"
}

# XXX annoyingly, this service cannot serve anything on macvlan on this same host
# One solution would be to serve these from dacodac instead
# Another would be to serve on host (assuming that even works)
# All this also begs the question of possibly conflicting with any other letsencrypt based utility on the same host
/*
module "router" {
  source        = "../modules/router"
  registry      = local.registry.address

  providers     = {
    docker  = docker.nuc
  }
  hostname      = local.networks.nuc.hostname
  networks      = {
    (local.networks.nuc.vlan): local.services.router.ip,
  }
  dns           = [
    local.services.reserved.dns_nuc,
  ]

  user          = "root"
  staging       = true
  domain        = var.domain
  email         = var.email

  auth_username = var.router_user
  auth_password = var.router_pwd
}

# Rethink the router

/*
# XXX annoyingly, this service cannot serve anything on macvlan on this same host
# One solution would be to serve these from dacodac instead
# Another would be to serve on host (assuming that even works)
# All this also begs the question of possibly conflicting with any other letsencrypt based utility on the same host
module "router" {
  source        = "./modules/system-router"
  providers     = {
    docker  = docker.nucomedon
  }

  hostname      = local.nuc.hostname
  user          = "root"

  networks      = {
    (module.network-nuc.vlan): local.nuc.router_ip,
  }

  dns           = [
    module.dns-nuc.ip,
  ]

  staging       = false
  domain        = var.domain
  email         = var.email

  auth_username = var.restricted_user
  auth_password = var.restricted_pwd

  # Just to force the dependency on the registry
  # This doesn't solve the problem - images are being checked before anything else and do not depend on the availability of any service
  # depends       = [module.registry.ip]
}
*/
