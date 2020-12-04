# Local indirection
locals {
  capabilities  = var.user == "root" ? ["NET_BIND_SERVICE"] : []
  command       = []
  devices       = []
  env           = [
    "DOMAIN=${var.domain}",
    "PULL=${var.pull}",
    "PUSH=${var.push}",
    "PORT=${local.internal_port}",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    // TODO make these configurable
    "MDNS=enabled",
    "TLS=internal",
    "SALT=eW91IGFyZSBzbyBzbWFydAo=",
    // XXX remove this with the new version of the registry
    "REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/data",
    "USERNAME_ADMIN=${var.username}",
    "PASSWORD_ADMIN=${var.password}",
  ]
  expose        = var.expose ? {
    (var.port): local.internal_port,
  } : {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {}
  mountsrw      = {
    "/data": var.data_path,
    "/certs": var.cert_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }

  internal_port = (var.user == "root" ? var.port : 4443)
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

# Service settings
variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
  // TODO enable after 0.14 sensitive   = false
}

variable "username" {
  description = "Restricted access to username"
  type        = string
  // TODO enable after 0.14 sensitive   = true
  // TODO enforce minimum length
}

variable "password" {
  description = "Restricted access password"
  type        = string
  // TODO enable after 0.14 sensitive   = true
  // TODO enforce length and content
}

variable "domain" {
  description = "Domain name to advertise (must be in the form of FOO.local if mDNS is enabled)"
  type        = string
  default     = "registry.local"
  // TODO enable after 0.14 sensitive   = false
  // TODO valid domain name
}

variable "pull" {
  description = "Whether to enable push access (anonymous or authenticated), or disable it (disabled)"
  type        = string
  default     = "authenticated"
  // TODO enable after 0.14 sensitive   = false
  validation {
    condition     = can(regex("^(?:disabled|anonymous|authenticated)$", var.pull))
    error_message = "Pull must be disabled, anonymous or authenticated."
  }
}

variable "push" {
  description = "Whether to enable push access (authenticated), or disable it (disabled)"
  type        = string
  default     = "disabled"
  // TODO enable after 0.14 sensitive   = false
  validation {
    condition     = can(regex("^(?:disabled|authenticated)$", var.push))
    error_message = "Push must be disabled or authenticated."
  }
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/data/registry"
  // TODO enable after 0.14 sensitive   = false
  // TODO valid path
}

variable "cert_path" {
  description = "Host path for persistent data & config"
  type        = string
  default     = "/home/container/certs/registry"
  // TODO enable after 0.14 sensitive   = false
  // TODO valid path
}

variable "port" {
  description = "Main port to expose"
  type        = number
  default     = 443
  // TODO enable after 0.14 sensitive   = false
  validation {
    // TODO figure out how to honor root vs. normal user
    condition     = var.port > 0  && var.port < 65536 // && (var.user == "root" || var.port > 1023)
    error_message = "The port must be in the range 1-65535."
  }
}
