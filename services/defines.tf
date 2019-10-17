#####################
# Input
#####################

variable "email" {
  description = "Email (to be used for letsencrypt certs for eg)"
  default     = "XXX"
}

variable "public_ip" {
  description = "Your public ip"
  default     = "127.0.0.1"
}

variable "public_key" {
  description = "Your public ssh key"
  default     = "/Users/dmp/.ssh/id_ed25519.pub"
}

variable "afp_server_name" {
  description = "Name advertised by the AFP server"
  default     = "Distributed Potatoid"
}

variable "afp_user" {
  description = "Users for afp"
  default     = "dmp"
}

variable "airport_dac_server_name" {
  description = "Name advertised by the dac airport server"
  default     = "Totale Croquette"
}

variable "airport_nuc_server_name" {
  description = "Name advertised by the nuc airport server"
  default     = "Nucomedon"
}

variable "airport_nig_server_name" {
  description = "Name advertised by the nig airport server"
  default     = "Nightingale"
}

variable "plex_server_name" {
  description = "Name advertised by the plex server"
  default     = "Sinema"
}

variable "plex_login" {
  description = "Plex account login"
  default     = "unknown"
}

variable "plex_password" {
  description = "Plex account password"
  default     = ""
}

# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
  gateway         = "192.168.1.1"
  subnet          = "192.168.1.0/24"

  dac_ip          = "192.168.1.7"
  dac_fact_iface  = "eth0"
  dac_range       = "192.168.1.20/28"
  dac_host        = "dacodac"
  dac_fact_user   = "pi"

  nig_ip          = "192.168.1.9"
  nig_fact_iface  = "wlan0.1"
  nig_range       = "192.168.1.60/28"
  nig_host        = "nightingale"
  nig_fact_user   = "pi"

  nuc_ip          = "192.168.1.8"
  nuc_fact_iface  = "eno1"
  nuc_range       = "192.168.1.40/28"
  nuc_host        = "nucomedon"
  nuc_fact_user   = "dmp"
}
