#####################
# Input
#####################

variable "logdna-key" {
  description = "secret key for logdna API"
  default     = "XXX"
}

variable "domain" {
  description = "Main domain"
  default     = "XXX"
}

variable "subs" {
  description = "Sub-domains to get a cert for"
  default     = "home"
  # movies,
}

variable "email" {
  description = "Email to be used for certs"
  default     = "XXX"
}

variable "afp_name" {
  description = "Hostname advertised by the AFP server"
  default     = "Distributed Potatoid"
}

# Audio stuff
variable "airport_croquette" {
  description = "name advertised by the dac"
  default     = "Totale Croquette"
}

variable "airport_nucomedon" {
  description = "name advertised by the nuc"
  default     = "Nucomedon"
}

variable "airport_nightingale" {
  description = "name advertised by the portable rasp"
  default     = "Nightingale"
}

# Home
resource "random_string" "afp_pwd" {
  length  = 30
  # XXX the way we change password in the docker image does not bode well with special chars apparently
  special = false
  number  = true
  upper   = true
  lower   = true
}

variable "afp_user" {
  description = "users for afp"
  default     = "dmp"
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
  dac_pgid        = "1000"
  dac_puid        = "1000"
  dac_range       = "192.168.1.20/28"
  dac_host        = "dacodac"
  dac_fact_user   = "pi"
  dac_fact_port   = "22"

  nuc_ip          = "192.168.1.8"
  nuc_fact_iface  = "eno1"
  nuc_pgid        = "1000"
  nuc_puid        = "1000"
  nuc_range       = "192.168.1.40/28"
  nuc_host        = "nucomedon"
  nuc_fact_user   = "dmp"
  nuc_fact_port   = "22"

  nig_ip          = "192.168.1.9"
  nig_fact_iface  = "wlan0.1"
  nig_pgid        = "1000"
  nig_puid        = "1000"
  nig_range       = "192.168.1.60/28"
  nig_host        = "nightingale"
  nig_fact_user   = "pi"
  nig_fact_port   = "22"

}
