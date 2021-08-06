# Local indirection
locals {
  container_expose = {}

  env           = [
    "MDNS_NAME=${var.station}"
  ]

  mounts        = {}
  mountsrw      = {}
  ramdisks      = {
    "/tmp": "1000000"
  }
  volumes       = {}
}

# Service settings
variable "station" {
  description = "Airport station name"
  type        = string
  default     = "Super Croquette"
}
