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
  default     = 53
  validation {
    // XXX cannot honor root vs. normal user in validation rules unfortunately...
    condition     = var.port > 0  && var.port < 65536
    error_message = "The port must be in the range 1-65535."
  }
}

# Service settings
variable "upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = ""
}

variable "upstream_ips" {
  description = "Upstream TLS DNS server ips"
  type        = list(string)
  default     = []
}

variable "healthcheck" {
  description = "Domain name to resolve for the healthchecked"
  type        = string
  default     = "dns.healthcheck.jsboot.space"
}
