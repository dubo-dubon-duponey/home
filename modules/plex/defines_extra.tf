####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  container_expose  = var.expose ? {
    443: 443,
    80: 80,
    32400: 32400,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env = [
    // Disable these two
    "MDNS_ENABLED=false",
    "PROXY_HTTPS_ENABLED=false",
    "HEALTHCHECK_URL=http://127.0.0.1:32400/?healthcheck=",

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
    "DBDB_LOGIN=${var.auth_username}",
    "DBDB_PASSWORD=${var.auth_password}",
    "DBDB_ADVERTISE_IP=${var.public_ip}",
    "DBDB_MAIL=${var.email}",
    // XXX temp hack
    "DBDB_SERVER_NAME=sinema.farcloser.world",
    // "DBDB_SERVER_NAME=${local.service_domain}"
  ]
}

locals {
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000000"
  }

  mounts        = (var.mtls != "" ? {
    "/media": var.movie_path
    "/certs/mtls_ca.crt": var.mtls_ca,
  } : {
    "/media": var.movie_path
  })

  volumes       = {
    // "/transcode": docker_volume.tmp.name
  }
  /*
  }
*/
}

/*
resource "docker_volume" "config" {
  provider      = docker
  name          = "config-${local.container_name}"
}
*/

