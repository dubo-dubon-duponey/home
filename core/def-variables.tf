# Generic configuration
variable "volumes_root" {
  description = "Root folder for all volume mounts (except media files)"
  default     = "/home/container"
}

variable "email" {
  description = "Your email (mainly used for letsencrypt validation)"
}

variable "domain" {
  description = "Your top level routing domain"
}

# DNS module
variable "dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
}

variable "dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
}

# Router
variable "restricted_user" {
  description = "User"
}

variable "restricted_pwd" {
  description = "Password"
}
