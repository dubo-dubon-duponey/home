# Local indirection
locals {
  container_expose = {}

  env           = [
    "HOMEKIT_NAME=${var.station}",
    "HOMEKIT_PIN=14041976",
    "IPS=10.0.4.169 10.0.4.154",
  ]

  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name
  }
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

# Service settings: use MDNS_ syntax instead
variable "station" {
  description = "HomeKit Bridge name"
  type        = string
  default     = "Wiz Bang"
}
