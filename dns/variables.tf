variable "token" {
  description = "Your Gandi token"
  type        = string
  default     = "ABCD"
}

variable "domain" {
  description = "Main domain where all your hosts and services are going to live in"
  type        = string
  default     = "example.com"
}

variable "subdomain_bastion" {
  description = "Subdomain for the 'bastion' host"
  type        = string
  default     = "host-bastion"
}

variable "subdomain_home" {
  description = "Subdomain for the 'home' host"
  type        = string
  default     = "host-home"
}

variable "static_ip" {
  description = "Existing floating ip on Digital Ocean, to be attached to the droplet"
  type        = string
  default     = "1.2.3.4"
}

variable "dyn_home" {
  description = "Dynamically updated hostname to point to, for the home CNAME"
  type        = string
  default     = "host.dyndns.example.com."
}
