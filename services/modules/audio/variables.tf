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
  description = "DNS server ip to use for this container"
  type        = list(string)
  default     = [
    "1.1.1.1",
  ]
}

variable "log" {
  description = "Whether to flag for filebeat log collection or not"
  type        = bool
  default     = false
}

variable "station" {
  description = "Station name"
  type        = string
  default     = "Totale Croquette"
}

variable "hw_index" {
  description = "Hardware index as reported by aplay -l"
  type        = number
  default     = 0
}

variable "mixer_name" {
  description = "Alsa mixer name"
  type        = string
  default     = "PCM"
}

variable "card_name" {
  description = "Card name"
  type        = string
  default     = "Mojo"
}

variable "volume" {
  description = "Initial volume"
  type        = number
  default     = 100
}
