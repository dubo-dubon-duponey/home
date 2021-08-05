# Local indirection
locals {
  container_expose = {}

  env           = [
    "NAME=${var.station}"
  ]

  mounts        = {}
  mountsrw      = {}
  ramdisks      = {}
  volumes       = {}
}

# Service settings
variable "station" {
  description = "Airport station name"
  type        = string
  default     = "Super Croquette"
}
