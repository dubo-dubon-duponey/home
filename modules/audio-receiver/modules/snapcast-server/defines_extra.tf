# Local indirection
locals {
  container_expose = {}

  env           = [
    "DOMAIN=snappy.local",
    "ADDITIONAL_DOMAINS=",

    "TLS=internal",
    // "TLS_AUTO=${var.tls_auto}",
    "AUTH=",
    //"AUTH=${var.auth}",
    //"AUTH_USERNAME=${var.auth_username}",
    //"AUTH_PASSWORD=${var.auth_password}",

    "MTLS=${var.mtls}",

    "LOG_LEVEL=${var.log_level}",

    "MODE=server",
    "MDNS_NAME=Dubo Snapcast Server",
    "MDNS_HOST=snappy",
    "MDNS_STATION=true",

    "SOURCES=${var.sources}",

    "SNAPCAST_TCP_ENABLED=true",
  ]

  mounts        = (var.mtls != "" ? {
    "/certs/mtls_ca.crt": var.mtls_ca,
  } : {})
  mountsrw      = {
    "/pipes": var.pipes_path,
    "/certs": var.cert_path,
  }
  volumes       = {
    // This is becoming big very fast (1GB), too big for tmfs
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
}

/*
# Service settings
variable "station" {
  description = "Spotify station name"
  type        = string
  default     = "Spotty Croquette"
}
*/

variable "pipes_path" {
  description = "Path for sound pipe"
  type        = string
}

variable "mtls" {
  description = "Set the mutual TLS behavior (verify_if_given or require_and_verify)"
  type        = string
  default     = "require_and_verify"
  validation {
    condition     = can(regex("^(?:|verify_if_given|require_and_verify|require|request|)$", var.mtls))
    error_message = "Mutual TLS mode must be one of verify_if_given, require_and_verify."
  }
}

variable "mtls_ca" {
  description = "What root CA to trust for client certificate verification"
  type        = string
  default     = "/somewhere/ca.crt"
}

variable "cert_path" {
  description = "Host path for persistent certificate management"
  type        = string
}

variable "sources" {
  description = "pipe or els"
  type        = string
}
