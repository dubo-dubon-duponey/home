variable "image" {
  description = "Image reference"
  type        = string
  default     = "dubodubonduponey/filebeat:v1"
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
  default     = [
    "1.1.1.1",
  ]
}

# Service specific configuration
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

# Local indirection
locals {
  # Image config
  image_reference         = var.image

  # Container config
  container_name          = var.nickname
  container_hostname      = "${var.nickname}.${var.hostname}"
  container_network       = var.network
  container_user          = var.privileged ? "root" : var.user
  container_dns           = var.dns

  # Healthcheck config
  healthcheck_url         = "http://${var.elastic}"

  # Logger
  log                     = var.log

  # Service config
  service_kibana          = var.kibana
  service_elastic         = var.elastic
}
