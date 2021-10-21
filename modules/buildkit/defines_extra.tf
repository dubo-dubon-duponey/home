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
    // XXX leftover from previous refactor
    "TLS_MODE=${var.tls}",
    "TLS_MIN=1.3",
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

    // **********************************
    // XXX review this
    "PORT=443",
    "PORT_HTTP=80",
    // XXX very wrong but trying to recover bk for now
    "HEALTHCHECK_URL=http://127.0.0.1:10042",
  ]
}

locals {
  mounts        = {
    # XXX fix this / generalize
    "/etc/ssl/certs/ca.pem": "/home/container/certs/ca.crt"
  }
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  volumes       = {
    "/run": docker_volume.run.name,
  }
  ramdisks      = {}
}

resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}
