variable "mdns_enabled" {
  description = "Whether to enable mDNS (this requires mac/ip vlan or host networking)"
  type        = bool
  default     = true
}

variable "mdns_host" {
  description = "mDNS host name to advertise (if unspecified, will default to the container nickname) (must NOT include '.local')"
  type        = string
  default     = ""
}

variable "mdns_name" {
  description = "mDNS fancy name to advertise (if left empty, will default to the container nickname)"
  type        = string
  default     = ""
}
