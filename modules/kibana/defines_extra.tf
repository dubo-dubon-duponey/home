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

    // +KIBANA specific
    "ELASTICSEARCH_HOSTS=${local.elastic_container}",
    // XXX unclear why but kibana will not use the os trust store... have to point it to the file...
    "ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES=/etc/ssl/certs/ca.pem",
    "ELASTICSEARCH_USERNAME=${var.elastic_username}",
    "ELASTICSEARCH_PASSWORD=${var.elastic_password}",
    // -KIBANA specific
  ]
}

locals {
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }
  mountsrw      = {
    "/certs": var.cert_path,
    "/data": var.data_path,
  }
  mounts        = {
    "/etc/ssl/certs/ca.pem": "${var.cert_path}/pki/authorities/local/root.crt"
  }

  # Service
  elastic_container     = var.elastic_container
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

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/elastic"
}

variable "elastic_container" {
  description = "Address of the elastic container (including scheme and port)"
  type        = string
}

variable "elastic_username" {
  description = "Optional elastic username"
  type        = string
  default     = ""
  sensitive   = true
}

variable "elastic_password" {
  description = "Optional elastic password"
  type        = string
  default     = ""
  sensitive   = true
}
