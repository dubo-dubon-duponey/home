variable "hostname" {
  description = "Base hostname for the container (container name will be added as a prefix)"
  type        = string
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

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = true
}
