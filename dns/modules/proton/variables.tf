variable "verification" {
  description = "ProtonMail TXT verification for the domain"
  type        = string
  default     = ""
}

variable "zone" {
  description = "Zone ID"
  type        = string
  default     = ""
}

variable "domainkey" {
  description = "Domain Key"
  type        = string
  default     = ""
}

variable "email" {
  description = "DMARC email"
  type        = string
  default     = "you+dmarc@pm.me"
}
