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
  description = "Whether to flag for filebeat log collection or not (disabled by default)"
  type        = bool
  default     = false
}

variable "station" {
  description = "Station name"
  type        = string
  default     = "Totale Croquette"
}

variable "device" {
  description = "Card name"
  type        = string
  default     = ""
}

variable "output" {
  description = "Output backend - alsa, pipe"
  type        = string
  default     = ""
}

/*
variable "hw_index" {
  description = "Hardware index as reported by aplay -l"
  type        = number
  default     = 0
}

*/

variable "mixer_name" {
  description = "Alsa mixer name"
  type        = string
  default     = ""
}

variable "master" {
  description = "Parent node (typically used to find snapcast server)"
  type        = string
  default     = "snappy.local"
}

variable "volume" {
  description = "Initial volume"
  type        = number
  default     = 75
}

variable "registry" {
  description = "Base registry for images"
  type        = string
  default     = "registry-1.docker.io"
}

variable "display_enabled" {
  description = "Enable display for Spotify"
  type        = bool
  default     = false
}

variable "spotify_id" {
  description = "Spot id for display"
  type        = string
  default     = ""
}

variable "spotify_secret" {
  description = "Spot secret for display"
  type        = string
  default     = ""
}

variable "mdns_nss" {
  description = "Whether to enable avahi resolution"
  type        = bool
  default     = true
}
