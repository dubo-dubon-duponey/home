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
    // XXX cannot honor root vs. normal user in validation rules unfortunately...
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

variable "username" {
  description = "Username to restrict access to"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.username) >= 3
    error_message = "Username must be at least three characters long."
  }
}

variable "password" {
  description = "Password to restrict access to (must be base64 bcrypt - see container function 'hash' for instructions on how to generate)"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.password) >= 10
    error_message = "Password must be a least 10 characters long."
  }
}

variable "realm" {
  description = "Realm for authentication"
  type        = string
  default     = "Is it a boy? Is it a girl? It's a poney!"
}

variable "tls" {
  description = "Set empty to disable TLS entirely, use 'internal' for self-signed certificates, or provide an email address for letsencrypt (you have to figure out networking for LE)"
  type        = string
  default     = "internal"
}

variable "domain" {
  description = "Domain name served by caddy over TLS (will default to nickname.local if left empty)"
  type        = string
  default     = ""
}
