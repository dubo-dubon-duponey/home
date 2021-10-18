####################################################################
# Extra configuration for containers that ship http services (common access-control, TLS and some networking definitions)
####################################################################

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = false
}

variable "mdns" {
  description = "Whether to enable mDNS (this requires mac/ip vlan or host networking)"
  type        = string
  default     = "_http._tcp"
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

variable "auth" {
  description = "Realm for authentication. Set to empty to disabled authentication."
  type        = string
  default     = "Is it a boy? Is it a girl? It's a poney!"
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

variable "tls" {
  description = "Set empty to disable TLS entirely, use 'internal' for self-signed certificates, or provide an email address for letsencrypt (you have to figure out networking for LE)"
  type        = string
  default     = "internal"
}

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

variable "data_path" {
  description = "Host path for persistent data"
  type        = string
}

variable "cert_path" {
  description = "Host path for persistent certificate management"
  type        = string
}
