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
    "TLS_MIN=1.2",
    "TLS_AUTO=${var.tls_auto}",

    "AUTH=${var.auth}",
    "AUTH_USERNAME=${var.auth_username}",
    "AUTH_PASSWORD=${var.auth_password}",

    "MTLS=${var.mtls}",
    "MTLS_TRUST=/config/mtls_ca.crt",

    "MDNS=${var.mdns}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
    "MDNS_STATION=true",

    "LOG_LEVEL=${var.log_level}",

    // Custom for this
    "ARCHITECTURES=${var.architectures}",
  ]
}

locals {
  mounts        = (var.mtls != "" ? {
    "/config/mtls_ca.crt": var.mtls_ca,
  } : {})
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "100000000000"
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

variable "architectures" {
  description = "Which architectures in the mirrors"
  type        = string
  default     = "armel,armhf,arm64,amd64,i386,s390x,ppc64el"
}
