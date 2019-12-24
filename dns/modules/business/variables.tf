variable "zone" {
  description = "Zone ID"
  type        = string
  default     = ""
}

variable "static_ip" {
  description = "Bastion static ip"
  type        = string
  default     = ""
}

variable "dyn_name" {
  description = "Dynamic CNAME"
  type        = string
  default     = ""
}

