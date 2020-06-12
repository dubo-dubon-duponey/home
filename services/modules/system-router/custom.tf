# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "DOMAIN=${var.domain}",
    "STAGING=${local.staging}",
    "EMAIL=${var.email}",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    "HTTP_PORT=${local.httpport}",
    "PROXY_PORT=${local.proxyport}",
    "HTTPS_PORT=${local.httpsport}",
    "METRICS_PORT=${local.metricsport}",
  ]
  // If in bridge, and if we want to expose, which ports
  expose        = var.expose ? {
    (var.httpport): local.httpport,
    (var.proxyport): local.proxyport,
    (var.httpsport): local.httpsport,
    (var.metricsport): local.metricsport,
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {
  }
  mounts        = {
    "/config/sites.d": "/home/container/config/router/sites.d",
    "/config/static": "/home/container/config/router/static",
  }
  mountsrw      = {}
  volumes       = {
    "/certs": docker_volume.certs.name,
    "/tmp": docker_volume.tmp.name,
  }

  # XXX hook and redo the port config management
  # Service config
  staging                 = var.staging ? "true" : ""
  domain                  = var.domain
  httpport                = (var.user == "root" ? var.httpport : 1080)
  proxyport               = (var.user == "root" ? var.proxyport : 1081)
  httpsport               = (var.user == "root" ? var.httpsport : 1443)
  metricsport             = (var.user == "root" ? var.metricsport : 9180)
  email                   = var.email
  user                    = var.username
  password                = var.password

  /*
  volumes {
    volume_name = docker_volume.tmp.name
    container_path = "/tmp"
  }
  */

}

/*
mounts {
  target      = "/config"
  source      = "${local.mount}/config"
  read_only   = true
  type        = "bind"
}

mounts {
  target      = "/data"
  source      = "${local.mount}/cache"
  read_only   = false
  type        = "bind"
}
*/


variable "httpport" {
  description = "Main port to expose"
  type        = string
  default     = "80"
}

variable "proxyport" {
  description = "Main secure port to expose"
  type        = string
  default     = "81"
}

variable "httpsport" {
  description = "Main secure port to expose"
  type        = string
  default     = "443"
}

variable "metricsport" {
  description = "Prometheus port to expose"
  type        = string
  default     = "9180"
}

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

# Service specific configuration
variable "domain" {
  description = "Main domain name to serve"
  type        = string
  default     = "dev-null.farcloser.world"
}

variable "email" {
  description = "Email to use by letsencrypt registration"
  type        = string
  default     = "you@something.com"
}

variable "staging" {
  description = "Staging for letsencrypt"
  type        = bool
  default     = true
}

variable "username" {
  description = "Restricted access to username"
  type        = string
}

variable "password" {
  description = "Restricted access password"
  type        = string
}

resource "docker_volume" "certs" {
  provider      = docker
  name          = "certs-${local.container_name}"
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

/*
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}
*/
