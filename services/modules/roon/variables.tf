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

variable "data_path" {
  description = "Host path for persistent config"
  type        = string
  default     = "/home/container/data/roon"
}

variable "music_path" {
  description = "Host path for mounted music collection folder"
  type        = string
  default     = "/home/data/audio"
}

locals {
  host_roon   = "roon"
  image_roon  = "dubodubonduponey/roon-server:v1"
}
