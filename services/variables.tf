# Audio module
variable "dac_audio_name" {
  description = "Name advertised by the Dacodac audio server"
  default     = "Totale Croquette"
}

variable "nuc_audio_name" {
  description = "Name advertised by the Nucomedon audio server"
  default     = "Nucomedon"
}

variable "nig_audio_name" {
  description = "Name advertised by the Nightingale audio server"
  default     = "Nightingale"
}

# DNS
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

# AFP server
variable "afp_server_name" {
  description = "Name advertised by the AFP server"
  default     = "Distributed Potatoid"
}

# Router
variable "restricted_user" {
  description = "User"
  default     = "dmp"
}

variable "restricted_pwd" {
  description = "Password"
  default     = "nhehehehe"
}

# Plex
# XXX probably useful for other than plex (eg: letsencrypt)
variable "email" {
  description = "Your email"
  default     = "you@me.com"
}

variable "volumes_root" {
  description = "Root folder for all volume mounts (except media files)"
  default     = "/home/container"
}

variable "public_ip" {
  description = "Your public ip (defaults to myip.opendns.com if empty)"
  default     = ""
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

