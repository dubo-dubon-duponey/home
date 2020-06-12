# Local indirection
locals {
  capabilities  = []
  command       = var.command
  devices       = [
    "/dev/snd",
  ]
  env           = [
    "NAME=${var.station}"
  ]
  expose        = {}
  expose_type   = "tcp"
  group_add     = [
    "audio",
  ]
  labels        = {}
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

variable "command" {
  description = "Extra command line arguments"
  type        = list(string)
  default     = [
    "-vv",
    "--statistics",
    "--",
    "-d",
    "hw:0",
  ]
}
