variable "image" {
  description = "Docker image reference to use for this module"
  type        = string
  default     = ""
}

variable "nickname" {
  description = "Container name"
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Base hostname for the container (container name will be added as a prefix)"
  type        = string
}

variable "user" {
  description = "User to run the container with (root may automatically add select caps and bind to priveleged ports)"
  type        = string
  default     = ""
}

variable "log" {
  description = "Whether to flag for filebeat log collection or not"
  type        = bool
  default     = true
}

variable "dns" {
  description = "DNS server ip(s) to use for this container"
  type        = list(string)
  default     = []
}

variable "networks" {
  description = "Map of networks to join (key) and optional ip (value)"
  type        = map(string)
  default     = {}
}

locals {
  # Image to use
  image_reference         = length(var.image) != 0 ? var.image : local.defaults.image

  # Container settings
  container_name          = length(var.nickname) != 0 ? var.nickname : local.defaults.nickname
  container_hostname      = "${local.container_name}.${var.hostname}"
  container_user          = var.user
  container_dns           = var.dns
  container_networks      = var.networks

  # Logger
  log                     = var.log
}
