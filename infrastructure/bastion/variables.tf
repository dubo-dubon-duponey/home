variable "token" {
  description = "Your Digital Ocean token"
  type        = string
  default     = "xxx-yyy"
}

variable "droplet_name" {
  description = "Name for the droplet (eg: /etc/hostname)"
  type        = string
  default     = "hostname.example.om"
}

variable "public_key" {
  description = "Public ssh key to authorize on the droplet 'docker' account"
  type        = string
  default     = "/foo/.ssh/pubkey"
}

locals {
  digital_ocean_region = "tor1"
}
