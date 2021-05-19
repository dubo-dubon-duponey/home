####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

// XXX provisional, for when we will hook-up caddy in front of the display server
/*
locals {
  // in-container port for the service - this will be public facing in case of a vlan or host network
  service_port      = (var.user == "root" ? var.port : local.defaults.port)
  // if expose is true (will be no-op if one of the network at least is not a bridge)
  container_expose  = var.expose ? {
    (var.port): local.service_port,
  } : {}

  service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env = [
    "LOG_LEVEL=${var.log_level}",
    "TLS=${var.tls}",
    "DOMAIN=${local.service_domain}",
    "PORT=${local.service_port}",
    "USERNAME=${var.username}",
    "PASSWORD=${var.password}",
    "REALM=${var.realm}",
    "MDNS_ENABLED=${var.mdns_enabled}",
    "MDNS_HOST=${local.mdns_host}",
    "MDNS_NAME=${local.mdns_name}",
  ]
}
*/
// If Roon would want to play:
// - add "/dev/snd" to the device list
// - add "audio" to group_add
// - likely rebuild the Roon image with libasound2 (currently not)
// Since we are now relying on the RoonBridge instead, this is useless

locals {
  env = []
  container_expose = {}
}

locals {
  mounts        = {
    "/music": var.music_path,
  }
  mountsrw      = {
    "/data": var.data_path,
  }
  volumes       = {
    "/tmp": docker_volume.tmp.name
  }
}

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

# Service specific configuration
variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
}

variable "music_path" {
  description = "Host path for mounted music collection folder"
  type        = string
}

/*
resource "docker_volume" "roon-data" {
  provider      = docker
  name          = "data-roon"
}
*/
