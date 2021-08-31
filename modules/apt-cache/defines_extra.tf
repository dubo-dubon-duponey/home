####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = var.port
  // if at least one of the networks is a bridge, and if expose is true
  container_expose  = var.expose ? {
    (var.port): local.service_port,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)
  tls_auto          = (var.tls_redirect_port == 0 ? "disable_redirects" : "ignore_loaded_certs")

  env = [
    "IS_PROXY=${var.is_proxy}",

    "PORT=${local.service_port}",
    "PORT_HTTP=${var.tls_redirect_port}",
    "DOMAIN=${local.service_domain}",
    "ADDITIONAL_DOMAINS=${var.additional_domains}",
    "TLS=${var.tls}",
    "TLS_MIN=${var.tls_min}",
    "TLS_MTLS_MODE=${var.tls_mtls_mode}",
//    "TLS_ISSUER=${var.tls_issuer}",
    "TLS_AUTO=${local.tls_auto}",
    "AUTH_ENABLED=${var.auth_enabled}",
    "AUTH_REALM=${var.auth_realm}",
    "AUTH_USERNAME=${var.auth_username}",
    "AUTH_PASSWORD=${var.auth_password}",
    "MDNS_ENABLED=${var.mdns_enabled}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
    "LOG_LEVEL=${var.log_level}",
  ]
}

locals {
  mounts        = {}
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {}
}

variable "data_path" {
  description = "Host path for persistent data"
  type        = string
}

variable "cert_path" {
  description = "Host path for persistent certificate management"
  type        = string
}
