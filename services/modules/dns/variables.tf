variable "hostname" {
  description = "Base hostname for the node"
  type        = string
  default     = "mynode.local"
}

variable "network" {
  description = "Network name"
  type        = string
  default     = "hack-net"
}

variable "upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = "dns.example.com"
}

variable "upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
  default     = [
    "1.2.3.4",
    "5.6.7.8",
  ]
}

locals {
  host        = "dns"
  image       = "dubodubonduponey/coredns:v1"

  address_1   = "tls://${var.upstream_ips[0]}"
  address_2   = "tls://${var.upstream_ips[1]}"
}
