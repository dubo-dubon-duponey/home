# Generic configuration
variable "volumes_root" {
  description = "Root folder for all volume mounts (except media files)"
  default     = "/home/container"
}

variable "email" {
  description = "Your email (mainly used for letsencrypt validation)"
}

variable "domain" {
  description = "Your top level routing domain"
}

# DNS module
variable "dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
}

variable "dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
}

# Audio module
variable "dac_audio_name" {
  description = "Name advertised by the Dacodac audio server"
  default     = "Totale Croquette"
}

variable "cor_audio_name" {
  description = "Name advertised by the Corpisone audio server"
  default     = "Corpisone"
}

variable "nig_audio_name" {
  description = "Name advertised by the Nightingale audio server"
  default     = "Nightingale"
}

# Video module
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
}

variable "plex_password" {
  description = "Plex account password"
}

# AFP server
variable "afp_server_name" {
  description = "Name advertised by the AFP server"
  default     = "Distributed Potatoid"
}

variable "afp_password" {
  description = "Account password for AFP/time mahine (randomly generated if empty)"
  default = ""
}

# Router
variable "restricted_user" {
  description = "User"
}

variable "restricted_pwd" {
  description = "Password"
}
