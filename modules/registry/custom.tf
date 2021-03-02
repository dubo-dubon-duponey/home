# Local indirection
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

    "PULL=${var.pull}",
    "PUSH=${var.push}",
  ]
}

locals {
  mounts        = {}
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/registry"
}

variable "cert_path" {
  description = "Host path for persistent data & config"
  type        = string
  // TODO move this away later on to a central (non service dependent location)
  // and/or mount the root cert from a location
  default     = "/home/container/certs/registry"
}

variable "pull" {
  description = "Whether to enable pull access (anonymous or authenticated), or disable it (disabled)"
  type        = string
  default     = "authenticated"
  validation {
    condition     = can(regex("^(?:disabled|anonymous|authenticated)$", var.pull))
    error_message = "Pull must be one of: 'disabled', 'anonymous' or 'authenticated'."
  }
}

variable "push" {
  description = "Whether to enable push access (authenticated), or disable it (disabled)"
  type        = string
  default     = "disabled"
  validation {
    condition     = can(regex("^(?:disabled|authenticated)$", var.push))
    error_message = "Push must be either 'disabled' or 'authenticated'."
  }
}
