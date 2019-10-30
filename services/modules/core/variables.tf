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

variable "elastic" {
  description = "Elastic host"
  type        = string
  default     = "elastic"
}

variable "kibana" {
  description = "Kibana host"
  type        = string
  default     = "kibana"
}

locals {
  host_dns      = "dns"
  host_logger   = "logger"
  image_dns     = "dubodubonduponey/coredns:v1"
  image_logger  = "dubodubonduponey/filebeat:v1"

  dns_upstream_address_1  = "tls://${var.dns_upstream_ips[0]}"
  dns_upstream_address_2  = "tls://${var.dns_upstream_ips[1]}"
}
