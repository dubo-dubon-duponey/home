variable "image_dns" {
  description = "Image to use for coredns"
  type        = string
  default     = "dubodubonduponey/coredns:v1"
}

variable "docker_config" {
  description = "Local path for local docker containers configuration"
  type        = string
  default     = "/Users/dmp/Projects/Configuration"
}

variable "dns_upstream_addresses" {
  description = "Upstream TLS DNS server urls"
  type        = string
  default     = "tls://1.2.3.4:123"
}

variable "dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = "dns.example.com"
}
