/*
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
*/

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

/*
variable "xxx_elastic" {
  description   = "xxxelastic"
  type          = string
  default       = "xxx_elastic"
}
*/

locals {
  image_reference_kibana  = "dubodubonduponey/kibana:v1"
  image_reference_elastic = "dubodubonduponey/elastic:v1"
  container_name_kibana   = "kibana"
  container_name_elastic  = "elastic"
  container_hostname_kibana   = "${local.container_name_kibana}.${var.hostname}"
  container_hostname_elastic  = "${local.container_name_elastic}.${var.hostname}"

  # Image config
  # image_reference         = var.image

  # Container config
  # container_name          = var.nickname
  # container_hostname      = "${var.nickname}.${var.hostname}"
  container_network       = var.network
  container_capabilities  = []
  container_user          = var.privileged ? "root" : var.user
  container_dns           = var.dns

  # Logger
  log                     = var.log

  # Service config
}
