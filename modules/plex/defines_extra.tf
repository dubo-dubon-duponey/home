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

    "MDNS=${var.mdns}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
    "MDNS_STATION=true",

    "LOG_LEVEL=${var.log_level}",

    // *******************************************
    "DBDB_LOGIN=${var.auth_username}",
    "DBDB_PASSWORD=${var.auth_password}",
    "DBDB_ADVERTISE_IP=${var.public_ip}",
    "DBDB_MAIL=${var.email}",
    "DBDB_SERVER_NAME=${local.service_domain}"
  ]
}

locals {
  mounts        = (var.mtls != "" ? {
    "/media": var.movie_path
    "/config/mtls_ca.crt": var.mtls_ca,
  } : {
    "/media": var.movie_path
  })
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {
    "/transcode": docker_volume.tmp.name
  }
}

variable "data_path" {
  description = "Host path for persistent data"
  type        = string
}

variable "cert_path" {
  description = "Host path for persistent certificate management"
  type        = string
}

/*
resource "docker_volume" "config" {
  provider      = docker
  name          = "config-${local.container_name}"
}
*/

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

variable "movie_path" {
  description = "Host path for mounted movie collection folder"
  type        = string
  default     = "/home/data/movie"
}

variable "public_ip" {
  description = "Plex publicly visible ip (defaults to myip.opendns.com)"
  type        = string
  default     = ""
}

// XXX check what this is and how to generalize
variable "email" {
  description = "Your email"
  type        = string
  default     = "you@me.com"
}
