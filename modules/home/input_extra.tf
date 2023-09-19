####################################################################
# Extra configuration for containers that ship http services (common access-control, TLS and some networking definitions)
####################################################################

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

variable "port" {
  description = "Service port: this controls the port exposed if in bridge networking, or if the user is root, the port being used inside the container in all other networking modes"
  type        = number
  default     = 443
  validation {
    condition     = var.port > 0  && var.port < 65536
    error_message = "The port must be in the range 1-65535."
  }
}

variable "mdns_enabled" {
  description = "Whether to enable mDNS (this requires mac/ip vlan or host networking)"
  type        = bool
  default     = true
}

variable "mdns_host" {
  description = "mDNS host name to advertise (if unspecified, will default to the container nickname) (must NOT include '.local')"
  type        = string
  default     = ""
}

variable "mdns_name" {
  description = "mDNS fancy name to advertise (if left empty, will default to the container nickname)"
  type        = string
  default     = ""
}

variable "auth_enabled" {
  description = "Whether to enable credentials authentication"
  type        = bool
  default     = true
}

variable "auth_username" {
  description = "Username to restrict access to"
  type        = string
  sensitive   = true
  default     = "dmp"
  validation {
    condition     = length(var.auth_username) >= 3
    error_message = "Username must be at least three characters long."
  }
}

variable "auth_password" {
  description = "Password to restrict access to (must be base64 bcrypt - see container function 'hash' for instructions on how to generate)"
  type        = string
  sensitive   = true
  default     = "bmhlaGVoZWhleW91d2lsbG5ldmVyZmluZG1lbG9sCg=="
  validation {
    condition     = length(var.auth_password) >= 10
    error_message = "Password must be a least 10 characters long."
  }
}

variable "auth_realm" {
  description = "Realm for authentication"
  type        = string
  default     = "Is it a boy? Is it a girl? It's a poney!"
}

variable "tls" {
  description = "Set empty to disable TLS entirely, use 'internal' for self-signed certificates, or provide an email address for letsencrypt (you have to figure out networking for LE)"
  type        = string
  default     = "internal"
}

variable "tls_min" {
  description = "Minimum TLS protocol version accepted by the server"
  type        = string
  default     = "1.3"
  validation {
    condition     = can(regex("^1.[2-3]{1}$", var.tls_min))
    error_message = "TLS min version must be one of 1.2 or 1.3."
  }
}

variable "mtls_mode" {
  description = "Set the mutual TLS behavior (verify_if_given or require_and_verify)"
  type        = string
  default     = "verify_if_given"
  validation {
    condition     = can(regex("^(?:verify_if_given|require_and_verify|require|request|)$", var.mtls_mode))
    error_message = "Mutual TLS mode must be one of verify_if_given or require_and_verify."
  }
}

//variable "tls_issuer" {
//  description = "Sets the name of the issuer"
//  type        = string
//  default     = "Dubo Dubon Duponey"
//}

variable "tls_auto" {
  description = "Set the TLS auto behavior (ignore_loaded_certs or disable_redirects)"
  type        = string
  default     = "disable_redirects"
  validation {
    condition     = can(regex("^(?:ignore_loaded_certs|disable_redirects)$", var.tls_auto))
    error_message = "Auto must be one of ignore_loaded_certs or disable_redirects."
  }
}

variable "domain" {
  description = "Domain name served by caddy over TLS (will default to nickname.local if left empty)"
  type        = string
  default     = ""
}

variable "additional_domains" {
  description = "Additional domains to be served (useful for proxy patterns)"
  type        = string
  default     = ""
}
