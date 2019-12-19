variable "image" {
  description = "Image reference"
  type        = string
  default     = "dubodubonduponey/plex:v1"
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
variable "data_path" {
  description = "Host path for persistent config"
  type        = string
  default     = "/home/container/data/plex"
}

variable "movie_path" {
  description = "Host path for mounted movie collection folder"
  type        = string
  default     = "/home/data/movie"
}

variable "login" {
  description = "Plex login"
  type        = string
  default     = "dmp"
}

variable "password" {
  description = "Plex password"
  type        = string
  default     = "nhehehehe"
}

variable "public_ip" {
  description = "Plex publicly visible ip (defaults to myip.opendns.com)"
  type        = string
  default     = ""
}

variable "email" {
  description = "Your email"
  type        = string
  default     = "you@me.com"
}

variable "station" {
  description = "Plex Station Name"
  type        = string
  default     = "Plexouille"
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

  # Logger
  log                     = var.log

  # Service config
  mount_data              = var.data_path
  mount_music             = var.movie_path

  login                   = var.login
  password                = var.password
  public_ip               = var.public_ip
  email                   = var.email
  station                 = var.station
}
