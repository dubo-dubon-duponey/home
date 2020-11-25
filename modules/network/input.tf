variable "subnet" {
  description = "Subnet for ip/mac vlan"
  type        = string
  default     = "192.168.1.0/24"
}

variable "gateway" {
  description = "Network gateway for ip/mac vlan"
  type        = string
  default     = "192.168.1.1"
}

variable "range" {
  description = "Range for ip/mac vlan"
  type        = string
  default     = "192.168.1.16/28"
}

variable "driver" {
  description = "Whether to use ipvlan or macvlan"
  type        = string
  default     = "macvlan"
}

variable "interface" {
  description = "Parent interface for ip/mac vlan"
  type        = string
  default     = "eth0"
}
