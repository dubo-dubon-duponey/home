####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  container_expose  = var.expose ? {
    443: 443,
    80: 80,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env = [
    "DOMAIN=${local.service_domain}",
    "ADDITIONAL_DOMAINS=${var.additional_domains}",

    "TLS=${var.tls}",
    "TLS_AUTO=${var.tls_auto}",

    "AUTH=${var.auth}",
    "AUTH_USERNAME=${var.auth_username}",
    "AUTH_PASSWORD=${var.auth_password}",

    "MTLS=${var.mtls}",

    "MDNS_TYPE=${var.mdns_type}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
    "MDNS_STATION=true",

    "LOG_LEVEL=${var.log_level}",

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
  mounts        = (var.mtls != "" ? {
    "/certs/mtls_ca.crt": var.mtls_ca,
    "/etc/ssl/certs/ca.pem": "${var.cert_path}/pki/authorities/local/root.crt"
  } : {
    "/etc/ssl/certs/ca.pem": "${var.cert_path}/pki/authorities/local/root.crt"
  })
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {}

  # Service
  elastic_container     = var.elastic_container
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
