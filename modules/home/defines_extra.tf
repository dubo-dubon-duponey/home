####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

#-v /etc/localtime:/etc/localtime:ro
#-v $(pwd)/home-assistant:/config  --network=host homeassistant/home-assistant:stable


locals {
  container_expose  = var.expose ? {
    8123: 8123
  } : {}
  // in-container port for the service - this will be public facing in case of a vlan or host network
  //service_port      = var.port
  // if expose is true (will be no-op if one of the network at least is not a bridge)
  //container_expose  = var.expose ? {
  //  (var.port): local.service_port,
  //} : {}

  // service_domain    = (var.domain != "" ? var.domain : "${local.container_name}.local")
  // mdns_host         = (var.mdns_host != "" ? var.mdns_host : local.container_name)
  // mdns_name         = (var.mdns_name != "" ? var.mdns_name : local.mdns_host)

  env = [
    "MPLCONFIGDIR=/tmp/config/mpl",
    // "HOME=/tmp/home",
  ]
}

locals {
  mounts        = {}
  mountsrw      = {
    "/config": var.data_path,
  }
  ramdisks      = {
    "/tmp": "1000000"
    // "/run": "1000000"
  }
  volumes       = {
    "/run": docker_volume.run.name
    // "/etc": docker_volume.etc.name
  }
}

variable "data_path" {
  description = "Host path for persistent data & config"
  type        = string
}

resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}

/*
resource "docker_volume" "etc" {
  provider      = docker
  name          = "etc-${local.container_name}"
}
*/

