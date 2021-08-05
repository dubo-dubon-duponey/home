####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = (var.user == "root" ? var.port : local.defaults.port)
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

    "DBDB_LOGIN=${var.auth_username}",
    "DBDB_PASSWORD=${var.auth_password}",
    "DBDB_ADVERTISE_IP=${var.public_ip}",
    "DBDB_MAIL=${var.email}",
    "DBDB_SERVER_NAME=${var.station}"
  ]
}

locals {
  mounts        = {
    "/media": var.movie_path
  }
  # For config and db, with write access and should be preserved durably
  # XXX maybe a volume would be enough?
  mountsrw      = {
    "/data": var.data_path
  }
  ramdisks      = {}
  volumes       = {
    "/transcode": docker_volume.tmp.name
  }
}

resource "docker_volume" "config" {
  provider      = docker
  name          = "config-${local.container_name}"
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

# Service specific configuration
variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/plex"
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

// XXX maybe de-duplicate with domain name?
variable "station" {
  description = "Plex Station Name"
  type        = string
  default     = "Plexouille"
}
