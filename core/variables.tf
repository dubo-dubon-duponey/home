# Generic configuration
variable "volumes_root" {
  description = "Root folder for all volume mounts (except media files)"
  default     = "/home/container"
}

variable "registry_address" {
  description = "Registry from where to pull the image"
  type        = string
}

variable "registry_username" {
  description = "Registry username to use"
  type        = string
}

variable "registry_password" {
  description = "Registry password to use"
  type        = string
}

# DNS module
variable "service_dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
}

variable "service_dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
}

variable "service_registry_username" {
  description = "Registry username to use"
  type        = string
}

variable "service_registry_password" {
  description = "Registry password to use"
  type        = string
}
