####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = var.port
  // if expose is true (will be no-op if one of the network at least is not a bridge)
  container_expose  = var.expose ? {
    (var.port): local.service_port,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env = [
    "PORT=${local.service_port}",
    "PORT_HTTP=${var.tls_redirect_port}",
    "DOMAIN=${local.service_domain}",
    "ADDITIONAL_DOMAINS=${var.additional_domains}",
    "TLS=${var.tls}",
    "TLS_MIN=${var.tls_min}",
    "TLS_MTLS_MODE=${var.tls_mtls_mode}",
//    "TLS_ISSUER=${var.tls_issuer}",
    "TLS_AUTO=${var.tls_auto}",
    "AUTH_ENABLED=${var.auth_enabled}",
    "AUTH_REALM=${var.auth_realm}",
    "AUTH_USERNAME=${var.auth_username}",
    "AUTH_PASSWORD=${var.auth_password}",
    "MDNS_ENABLED=${var.mdns_enabled}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
    "LOG_LEVEL=${var.log_level}",

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
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {}
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
}

variable "cert_path" {
  description = "Host path for persistent data & config"
  type        = string
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
