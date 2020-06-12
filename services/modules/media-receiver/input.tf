variable "hostname" {
  description = "Base hostname for the container (container name will be added as a prefix)"
  type        = string
  default     = "receiver.local"
}

variable "dns" {
  description = "DNS server ip(s) to use for this container"
  type        = list(string)
  default     = []
}

variable "networks" {
  description = "Map of networks to join (key) and optional ip (value)"
  type        = map(string)
  default     = {}
}

variable "log" {
  description = "Whether to flag for filebeat log collection or not"
  type        = bool
  default     = true
}

variable "user" {
  description = "User to run the container with (root may automatically add select caps and bind to priveleged ports)"
  type        = string
  default     = ""
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
