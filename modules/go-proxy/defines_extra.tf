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
    "ATHENS_GO_BINARY_ENV_VARS=GOPROXY=${var.goproxy}",
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
  // XXX turns out this is problematic - at 1G it still exhausts with some modules (not sure why they would be so big)
  // In a shell: athens downloads to /tmp, then move to storage /data
  ramdisks      = {
    "/tmp": "8000000000"
  }
  volumes       = {}
}

variable "goproxy" {
  description = "Control the way athens behave"
  default     = "direct"
  type        = string
}
