####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = (var.user == "root" ? var.port : local.defaults.port)
  // if at least one of the networks is a bridge, and if expose is true
  container_expose  = var.expose ? {
    (var.port): local.service_port,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env = [
    "LOG_LEVEL=warn",
    "TLS=${var.tls}",
    "DOMAIN=${local.service_domain}",
    "PORT=${local.service_port}",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    "REALM=${var.realm}",
    "MDNS_ENABLED=${var.mdns_enabled}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
  ]

  // XXX note this container cannot run as root, because Elastic will refuse to do so, and chroot is a nightmare to get in that case

  // right here, mostly because of elastic configuration mutability
  mounts        = {
  }
  mountsrw      = {
    "/certs": var.cert_path,
    "/data": var.data_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

variable "cert_path" {
  description = "Host path for persistent data & config"
  type        = string
  // TODO move this away later on to a central (non service dependent location)
  // Replace this by a mount of the root ca, and let caddy manage the rest in a volume
  default     = "/home/container/certs/elastic"
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/elastic"
}
