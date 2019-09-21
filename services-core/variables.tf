variable "image_dns" {
  description = "Image to use for coredns"
  type        = string
  default     = "dubodubonduponey/coredns:v1"
}

variable "dns_name" {
  description = "DNS-TLS server name"
  type        = string
  default     = "dns.example.com"
}

variable "static_ip" {
  description = "Existing floating ip on Digital Ocean, to be attached to the droplet"
  type        = string
  default     = "1.2.3.4"
}

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

locals {
  dns_upstream_addresses = "tls://${var.dns_upstream_ips[0]} tls://${var.dns_upstream_ips[1]}"
}
