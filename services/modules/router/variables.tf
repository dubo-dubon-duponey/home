variable "image" {
  description = "Image reference"
  type        = string
  default     = "dubodubonduponey/caddy:v1"
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
variable "domain" {
  description = "Main domain name to serve"
  type        = string
  default     = "dev-null.farcloser.world"
}

variable "email" {
  description = "Email to use by letsencrypt registration"
  type        = string
  default     = "you@something.com"
}

variable "staging" {
  description = "Staging for letsencrypt"
  type        = bool
  default     = true
}

variable "kibana" {
  description = "ip/port of the kibana server"
  type        = string
  default     = "kibana_host_port"
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
  domain                  = var.domain
  email                   = var.email
  staging                 = var.staging ? "true" : ""
  kibana                  = var.kibana
  user                    = "dmp"
  password                = "totototo"
}
