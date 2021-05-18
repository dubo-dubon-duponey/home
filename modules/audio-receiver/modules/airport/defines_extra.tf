# Local indirection
locals {
  container_expose = {}

  env           = [
    "NAME=${var.station}"
  ]

  mounts        = {}
  mountsrw      = {}
  volumes       = {}
}

# Service settings
variable "station" {
  description = "Airport station name"
  type        = string
  default     = "Super Croquette"
}
