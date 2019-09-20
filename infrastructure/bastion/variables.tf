variable "token" {
  description = "Your Digital Ocean token"
  type        = string
  default     = "xxx-yyy"
}

variable "static_ip" {
  description = "Existing floating ip on Digital Ocean, to be attached to the droplet"
  type        = string
  default     = "1.2.3.4"
}

variable "droplet_name" {
  description = "Name for the droplet (eg: /etc/hostname)"
  type        = string
  default     = "something.example.om"
}

variable "public_key" {
  description = "Public ssh key to authorize on the droplet 'docker' account"
  type        = string
  default     = "/foo/.ssh/pubkey"
}

locals {
  digital_ocean_region = "tor1"
}

