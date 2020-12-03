# Local indirection
locals {
  capabilities  = []
  command       = []
  devices       = []
  env           = [
    "HOMEKIT_NAME=${var.station}",
    "HOMEKIT_PIN=14041976",
    "IPS=10.0.4.207 10.0.4.208",
  ]
  expose        = {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {}
  mounts        = {}
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name
  }
}

# Service settings
variable "station" {
  description = "HomeKit Bridge name"
  type        = string
  default     = "Wiz Bang"
}

# Volumes
resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}
