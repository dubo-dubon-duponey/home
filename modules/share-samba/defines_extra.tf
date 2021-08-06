# XXX if password was generated, this should output
# XXX is this really a necessity?
#  provisioner "local-exec" {
#    command = "echo 'Users have been configured for netatalk: ${local.users} (${local.passwords}). This will never be displayed ever again.'"
#  }

# Local indirection
locals {
  container_expose = {}
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env           = [
    "USERS=${local.users}",
    "PASSWORDS=${local.passwords}",
    "MDNS_ENABLED=${var.mdns_enabled}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
  ]

  // If in bridge, and if we want to expose, which ports
  mounts        = {}
  mountsrw      = {
    "/media/timemachine": "/home/volatile/timemachine",
    "/media/share": "/home/data/share",
    "/media/home": "/home/data/home",
  }
  ramdisks      = {
    "/tmp": "1000000000"
  }
  volumes       = {
    "/data": docker_volume.data.name,
    "/etc": docker_volume.etc.name,
  }

  # Service config
  users                   = join(" ", var.users)
  passwords               = join(" ", var.passwords)
}
/*
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}
*/
resource "docker_volume" "etc" {
  provider      = docker
  name          = "etc-${local.container_name}"
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

/*
resource "docker_volume" "log" {
  provider      = docker
  name          = "log-${local.container_name}"
}

# Service specific configuration - XXX migrate to self mDNS instead of this garbage
variable "station" {
  description = "Name advertised by the service"
  type        = string
  default     = "Time Machine"
}
*/
variable "users" {
  description = "List of user accounts"
  type        = list(string)
  default     = ["dmp"]
}

variable "passwords" {
  description = "List of user passwords"
  type        = list(string)
  default     = ["nhehehehe"]
}
