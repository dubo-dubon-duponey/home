variable "token" {
  description = "Your Gandi token"
  type        = string
  default     = "ABCD"
}

variable "static-ip" {
  description = "Existing floating ip on Digital Ocean, to be attached to the droplet"
  type        = string
  default     = "1.2.3.4"
}

variable "dyn-name" {
  description = "Dynamically updated hostname to point to, for the home CNAME"
  type        = string
  default     = "host.dyndns.example.com."
}

variable "dmarc-email" {
  description = "Email to send the dmarc reports to"
  type        = string
  default     = ""
}


# Per domain proton settings
variable "jsboot-net-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "jsboot-net-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}

variable "jsboot-com-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "jsboot-com-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}

variable "farcloser-world-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "farcloser-world-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}

variable "loop-dev-com-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "loop-dev-com-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}

variable "webitup-fr-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "webitup-fr-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}

variable "jsboot-space-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "jsboot-space-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}

variable "gambier-email-verification" {
  description = "Verification key for Proton"
  type        = string
  default     = ""
}

variable "gambier-email-domainkey" {
  description = "Domain key for Proton"
  type        = string
  default     = ""
}
