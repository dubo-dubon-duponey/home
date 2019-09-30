variable "image_dns" {
  description = "Image to use for coredns"
  type        = string
  default     = "dubodubonduponey/coredns:v1"
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

variable "certificate_domain" {
  description = "DNS-TLS server name"
  type        = string
  default     = "dns.example.com"
}

variable "certificate_email" {
  description = "Email to be used for letsencrypt"
  type        = string
  default     = "o@example.com"
}

variable "static_ip" {
  description = "Public IP of the machine"
  type        = string
  default     = "1.2.3.4"
}

locals {
  # XXX broken right now
  #  dns_upstream_addresses = "tls://${var.dns_upstream_ips[0]} tls://${var.dns_upstream_ips[1]}"
  dns_upstream_addresses = "tls://${var.dns_upstream_ips[0]}"
}
