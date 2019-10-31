variable "hostname" {
  description = "Base hostname for the node"
  type        = string
  default     = "mynode.local"
}

variable "network" {
  description = "Network name"
  type        = string
  default     = "hack-net"
}

variable "dns" {
  description = "DNS server ip"
  type        = list(string)
  default     = [
    "1.1.1.1",
  ]
}

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

locals {
  host        = "logger"
  image       = "dubodubonduponey/filebeat:v1"
}
