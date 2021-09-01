# Local indirection
locals {
  container_expose = {}

  env           = [
    "MODE=server",
    "MDNS_ENABLED=true",
    "MDNS_NAME=Dubo Snapcast Server",
    "MDNS_HOST=snappy"
  ]

  mounts        = {}
  mountsrw      = {
    "/pipes": var.pipes_path,
  }
  volumes       = {
    // This is becoming big very fast (1GB), too big for tmfs
  }
  ramdisks      = {
    "/tmp": "1000000"
  }
}

/*
# Service settings
variable "station" {
  description = "Spotify station name"
  type        = string
  default     = "Spotty Croquette"
}
*/

variable "pipes_path" {
  description = "Path for sound pipe"
  type        = string
}
