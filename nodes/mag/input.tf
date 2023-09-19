# Generic configuration
variable "volumes_root" {
  description = "Root folder for all volume mounts (except media files)"
  type        = string
  default     = "/home/container"
}

variable "registry_address" {
  description = "Registry from where to pull the image"
  type        = string
}

variable "registry_username" {
  description = "Registry username to use"
  type        = string
}

variable "registry_password" {
  description = "Registry password to use"
  type        = string
}

# DNS module
variable "service_dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
}

variable "service_dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
}

# Audio module
variable "service_audio_name" {
  description = "Name advertised by the receiver"
  type        = string
  default     = "Magnetar"
}

variable "service_audio_device" {
  description = "Device to use"
  type        = string
  default     = "default:CARD=Mojo"
}

variable "service_audio_mixer" {
  description = "Mixer to use"
  type        = string
  default     = ""
}

variable "service_audio_volume" {
  description = "Initial volume"
  type        = number
  default     = 75
}

variable "service_master" {
  description = "Mixer to use"
  type        = string
  default     = "snappy.local"
}

variable "mdns_nss" {
  description = "Whether to have avahi and service mDNS-NSS"
  type        = bool
  default     = false
}
