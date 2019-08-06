variable "ip" {
  description = "machine current ip"
  default     = "192.168.1.8"
}

variable "hostname" {
  description = "hostname to set on the machine"
  default     = "nuc8"
}

variable "os" {
  description = "os of the host (supported: raspbian, debian)"
  default     = "debian"
}

variable "iface" {
  description = "interface to the world"
  default     = "eno1"
}

variable "user" {
  description = "factory user"
  default     = "pi"
}

variable "password" {
  description = "factory password"
  default     = "raspberry"
}

# Credentials and other static info
variable "ssh_public_key" {
  description = "ssh public key file to use"
  default     = "/Users/dmp/.ssh/id_ed25519.pub"
}

variable "dac_disable_blue" {
  description = "whether to hard disable bluetooth on raspberry pi"
  default     = ""
}

variable "dac_disable_wifi" {
  description = "whether to hard disable wifi on raspberry pi"
  default     = ""
}

variable "dac_disable_audio" {
  description = "whether to hard disable audio on raspberry pi"
  default     = ""
}

variable "wifi_ssid" {
  description = "ssid"
  default     = ""
}

variable "wifi_psk" {
  description = "pre-shared key"
  default     = ""
}

locals {
  factory_port    = "22"
}

# New, randomly generated password that will replace the previous ones on-first time init
resource "random_string" "new_pwd" {
  length  = 30
  special = true
  number  = true
  upper   = true
  lower   = true
}

provider "random" {
  version = "~> 2.1"
}
