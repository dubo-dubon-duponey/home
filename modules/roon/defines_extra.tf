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
  ]
}

// If Roon would want to play:
// - add "/dev/snd" to the device list
// - add "audio" to group_add
// - likely rebuild the Roon image with libasound2 (currently not)
// Since we are now relying on the RoonBridge instead, this is useless


locals {
  mounts        = (var.mtls != "" ? {
    "/music": var.music_path,
    "/config/mtls_ca.crt": var.mtls_ca,
  } : {
    "/music": var.music_path,
  })
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {}
}

variable "music_path" {
  description = "Host path for mounted music collection folder"
  type        = string
}

/*
resource "docker_volume" "roon-data" {
  provider      = docker
  name          = "data-roon"
}
*/
