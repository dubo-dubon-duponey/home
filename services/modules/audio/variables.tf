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

variable "airport_name" {
  description = "Airport station name"
  type        = string
  default     = "Super Croquette"
}

variable "airport_cmd" {
  description = "Extra command line arguments"
  type        = list(string)
  default     = [
    "-vv",
    "--statistics",
    "--",
    "-d",
    "hw:0",
  ]
}

locals {
  host_airport          = "airport"
  image_volume_control  = "dubodubonduponey/homekit-alsa:v1"
  image_airport_server  = "dubodubonduponey/shairport-sync:v1"
}
