####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = (var.user == "root" ? var.port : local.defaults.port)
  // if expose is true (will be no-op if one of the network at least is not a bridge)
  container_expose  = var.expose ? {
    (var.port): local.service_port,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env           = [
    "LOG_LEVEL=${var.log_level}",
    "TLS=${var.tls}",
    "DOMAIN=${local.service_domain}",
    "PORT=${local.service_port}",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    "REALM=${var.realm}",
    "MDNS_ENABLED=${var.mdns_enabled}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",

    "ATHENS_DISK_STORAGE_ROOT=/tmp/athens",
    "ATHENS_STORAGE_TYPE=disk",
    #    "ATHENS_PORT=:${local.port}",
  ]
}

locals {
  mounts        = {}
  mountsrw      = {
    "/certs": var.cert_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name,
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
  // and/or mount the root cert from a location
  default     = "/home/container/certs/registry"
}
