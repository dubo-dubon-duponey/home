variable "hostname" {
  description   = "Base hostname for the node"
  type          = string
  default       = "mynode.local"
}

variable "network" {
  description   = "Network name"
  type          = string
  default       = "hack-net"
}

variable "dns" {
  description = "DNS server ip"
  type        = list(string)
  default     = [
    "1.1.1.1",
  ]
}

variable "xxx_elastic" {
  description   = "xxxelastic"
  type          = string
  default       = "xxx_elastic"
}

locals {
  host_kibana   = "kibana"
  host_elastic  = "elastic"
  image_kibana  = "dubodubonduponey/kibana:v1"
  image_elastic = "dubodubonduponey/elastic:v1"
}
