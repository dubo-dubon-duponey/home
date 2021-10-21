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
    "TLS_MIN=1.2", // At least macos webdav client is not happy with 1.3 - public properties still need 1.2 for now
    "TLS_AUTO=${var.tls_auto}",

    "AUTH=${var.auth}",
    "AUTH_USERNAME=${var.auth_username}",
    "AUTH_PASSWORD=${var.auth_password}",

    "MTLS=${var.mtls}",
    "MTLS_TRUST=/config/mtls_ca.crt",

    "MDNS_TYPE=${var.mdns_type}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
    "MDNS_STATION=true",

    "LOG_LEVEL=${var.log_level}",

    "STAGING=${local.staging}",
  ]
}

locals {
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
  }

  // XXX what a fucking tangle
  mounts        = (var.mtls != "" ? {
    "/config/mtls_ca.crt": var.mtls_ca,
    "/config/caddy/sites.d": "/home/container/config/router/sites.d",
    "/config/caddy/static": "/home/container/config/router/static",
  } : {
    "/config/caddy/sites.d": "/home/container/config/router/sites.d",
    "/config/caddy/static": "/home/container/config/router/static",
  })

  volumes = {}

  # Service config
  staging                 = var.staging ? "true" : ""

}

// XXX centralize
variable "staging" {
  description = "Staging for letsencrypt"
  type        = bool
  default     = true
}

