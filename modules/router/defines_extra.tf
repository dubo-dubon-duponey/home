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
    "MOD_TLS_ENABLED=false",

    "MOD_BASICAUTH_ENABLED=true",
    "MOD_BASICAUTH_REALM=${var.auth}",
    "MOD_BASICAUTH_USERNAME=${var.auth_username}",
    "MOD_BASICAUTH_PASSWORD=${var.auth_password}",

    "MOD_MDNS_ENABLED=true",
    "MOD_MDNS_HOST=${local.mdns_host}",
    "MOD_MDNS_NAME=${local.mdns_name}",

    "ADVANCED_MOD_MDNS_TYPE=${var.mdns_type}",
    "ADVANCED_MOD_MDNS_STATION=true",

    "MOD_HTTP_ENABLED=true",
    "MOD_HTTP_TLS_MODE=${var.tls}",
    "ADVANCED_MOD_HTTP_ADDITIONAL_DOMAINS=${var.additional_domains}",
    "ADVANCED_MOD_HTTP_TLS_MIN=1.2", // At least macos webdav client is not happy with 1.3 - public properties still need 1.2 for now
    "ADVANCED_MOD_HTTP_TLS_AUTO=${var.tls_auto}",

    "MOD_MTLS_ENABLED=true",
    "MOD_MTLS_MODE=${var.mtls}",

    "DOMAIN=${local.service_domain}",
    "LOG_LEVEL=${var.log_level}",
    "STAGING=${local.staging}",
  ]
}


/*
DOMAIN=farcloser.world
LOG_LEVEL=info
ADVANCED_MOD_MTLS_TRUST=/certs/pki/authorities/local/root.crt

ADVANCED_MOD_HTTP_PORT=443
ADVANCED_MOD_HTTP_PORT_INSECURE=80
ADVANCED_MOD_HTTP_SERVER_NAME=DuboDubonDuponey/1.0 (Caddy/2) [router]
ADVANCED_MOD_HTTP_TLS_SERVER=https://acme-v02.api.letsencrypt.org/directory

*/

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
    "/certs/mtls_ca.crt": var.mtls_ca,
    "/config/caddy/sites.d": "${var.config_mounts}/sites.d",
    "/config/caddy/static": "${var.config_mounts}/static",
    "/config/caddy/main.conf": "${var.config_mounts}/main.conf",
    "/config/goello": "${var.config_mounts}/goello",
  } : {
    "/config/caddy/sites.d": "${var.config_mounts}/sites.d",
    "/config/caddy/static": "${var.config_mounts}/static",
    "/config/goello": "${var.config_mounts}/goello",
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

variable "config_mounts" {
  description = "Where to find sites.d and static"
  type        = string
  default     = "/home/container/config/router"
}
