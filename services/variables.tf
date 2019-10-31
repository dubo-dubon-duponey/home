variable "dac_audio_name" {
  description = "Name advertised by the Dacodac airport server"
  default     = "Totale Croquette"
}

variable "nuc_audio_name" {
  description = "Name advertised by the Nucomedon airport server"
  default     = "Nucomedon"
}

variable "nig_audio_name" {
  description = "Name advertised by the Nightingale airport server"
  default     = "Nightingale"
}

variable "dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = "dns.example.com"
}

variable "dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
  default     = [
    "1.2.3.4",
    "5.6.7.8",
  ]
}


# XXX
variable "afp_server_name" {
  description = "Name advertised by the AFP server"
  default     = "Distributed Potatoid"
}

variable "afp_user" {
  description = "Users for afp"
  default     = "dmp"
}
