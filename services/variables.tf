# Generic configuration
variable "volumes_root" {
  description = "Root folder for all volume mounts (except media files)"
  default     = "/home/container"
}

variable "registry_address" {
  description = "Registry from where to pull the image"
  type        = string
}

variable "registry_username" {
  description = "Registry username to use"
  type        = string
}

variable "registry_password" {
  description = "Registry password to use"
  type        = string
}

# DNS module
variable "service_dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
}

variable "service_dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
}

# Audio module
variable "lounge_name" {
  description = "Name advertised by the Dacodac audio server"
  default     = "Totale Croquette"
}

variable "desk_name" {
  description = "Name advertised by the Corpisone audio server"
  default     = "Corpisone"
}

variable "bedroom_name" {
  description = "Name advertised by the Nightingale audio server"
  default     = "Nightingale"
}

variable "email" {
  description = "Your email (mainly used for letsencrypt validation)"
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
  description = "Account password for AFP/time machine (randomly generated if empty)"
  default = ""
}

variable "push_registry_username" {
  description = "User for the push registry"
}

variable "push_registry_password" {
  description = "Passowrd for the push registry"
}

/*

variable "domain" {
  description = "Your top level routing domain"
}

# Router
variable "restricted_user" {
  description = "User"
}

variable "restricted_pwd" {
  description = "Password"
}
*/
