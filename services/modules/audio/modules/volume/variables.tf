variable "image" {
  description = "Image reference"
  type        = string
  default     = "dubodubonduponey/homekit-alsa:v1"
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

# Service settings
variable "station" {
  description = "HomeKit device name"
  type        = string
  default     = "Croquettas Ballas"
}

variable "device" {
  description = "Alsa device"
  type        = string
  default     = "PCM"
}

variable "card" {
  description = "Alsa card"
  type        = string
  default     = "0"
}

locals {
  image_reference         = var.image

  container_name          = var.nickname
  container_hostname      = "${var.nickname}.${var.hostname}"
  container_network       = var.network
  container_user          = var.privileged ? "root" : var.user
  container_dns           = var.dns

  # Logger
  log                     = var.log

  # Service
  station                 = var.station
  device                  = var.device
  card                    = var.card
}
