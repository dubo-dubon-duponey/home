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

variable "spot_name" {
  description = "Spotify station name"
  type        = string
  default     = "Spotty Croquette"
}

variable "spot_cmd" {
  description = "Extra command line arguments"
  type        = list(string)
  default     = [
    "--mixer-name=PCM",
    "--mixer-card=hw:0",
    "--enable-volume-normalisation",
    "--initial-volume",
    "75",
  ]
}

variable "alsa_device" {
  description = "Alsa device"
  type        = string
  default     = ""
}

locals {
  host_airport          = "airport"
  host_raat             = "raat"
  host_volume           = "volume"
  host_spot             = "spot"
  image_volume_control  = "dubodubonduponey/homekit-alsa:v1"
  image_airport_server  = "dubodubonduponey/shairport-sync:v1"
  image_raat_server     = "dubodubonduponey/roon-bridge:v1"
  image_spot_server     = "dubodubonduponey/librespot:v1"
}
