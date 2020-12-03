variable "prefix" {
  description = "Name prefix for the created networks"
  type        = string
  default     = "dubo-core-"
}

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
  default     = ""
}

variable "aux_address" {
  description = "Auxiliary address for the vlan network"
  type        = map(string)
  default     = {}
}

