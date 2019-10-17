variable "dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = "dns.example.com"
}

variable "dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
  default     = [
    "1.2.3.4",
    "5.6.7.8",
  ]
}

variable "docker_config" {
  description = "Local path for local docker containers configuration"
  type        = string
  default     = "/home/container"
}

locals {
  dns_upstream_address_1 = "tls://${var.dns_upstream_ips[0]}"
  dns_upstream_address_2 = "tls://${var.dns_upstream_ips[1]}"
}
