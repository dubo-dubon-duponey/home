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

    "ARCHITECTURES=${var.architectures}",
  ]
}

locals {
  mounts        = {}
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
    "/tmp": var.tmp_path,
  }
  volumes       = {
//    "/tmp": docker_volume.tmp.name
  }
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/apt-mirror"
}

variable "cert_path" {
  description = "Host path for persistent data & config"
  type        = string
  // TODO move this away later on to a central (non service dependent location)
  // and/or mount the root cert from a location
  default     = "/home/container/certs/registry"
}

variable "tmp_path" {
  description = "Host path for transient data"
  type        = string
  default     = "/home/container/data/apt-mirror/tmp"
}

variable "architectures" {
  description = "Which architectures in the mirrors"
  type        = string
  default     = "armel,armhf,arm64,amd64,i386,s390x,ppc64el"
}
