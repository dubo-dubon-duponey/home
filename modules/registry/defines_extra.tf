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

    // *******************************************
    "PULL=${var.pull}",
    "PUSH=${var.push}",
  ]
}

locals {
  mounts        = (var.mtls != "" ? {
    "/certs/mtls_ca.crt": var.mtls_ca,
  } : {})
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {}
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
