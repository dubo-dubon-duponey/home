variable "image" {
  description = "Image reference"
  type        = string
  default     = "dubodubonduponey/coredns:v1"
}

variable "nickname" {
  description = "Nickname for the service"
  type        = string
  default     = "nick"
}

variable "hostname" {
  description = "Base hostname for the node"
  type        = string
  default     = "mynode.local"
}

variable "privileged" {
  description = "Whether we grant privileges to this container"
  type        = bool
  default     = false
}

variable "user" {
  description = "User to run the container with, if not privileged"
  type        = string
  default     = ""
}

variable "log" {
  description = "Whether to flag for filebeat log collection or not"
  type        = bool
  default     = false
}

variable "network" {
  description = "Network name"
  type        = string
  default     = "hack-net"
}

variable "dns" {
  description = "DNS server ip to use for this container"
  type        = list(string)
  default     = []
}

# Service specific configuration
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

# Local indirection
locals {
  # Image config
  image_reference         = var.image

  # Container config
  container_name          = var.nickname
  container_hostname      = "${var.nickname}.${var.hostname}"
  container_network       = var.network
  container_capabilities  = var.privileged ? ["NET_BIND_SERVICE"] : []
  container_user          = var.privileged ? "root" : var.user
  container_dns           = var.dns

  # Healthcheck config
  healthcheck_question    = "dev.farcloser.world"

  # Logger
  log                     = var.log

  # Service config
  # Service config
  dns_upstream_1          = "tls://${var.upstream_ips[0]}"
  dns_upstream_2          = "tls://${var.upstream_ips[1]}"
  dns_upstream_name       = var.upstream_name

  dns_port                = var.privileged ? 53 : 1053
}
