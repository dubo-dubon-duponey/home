# Local indirection
locals {
  container_expose = {}

  env           = [
    "NAME=${var.station}",
    "PORT=10042",
    "DISPLAY_ENABLED=${var.display_enabled}",
    "SPOTIFY_CLIENT_ID=${var.spotify_id}",
    "SPOTIFY_CLIENT_SECRET=${var.spotify_secret}",
  ]

  mounts        = {}
  mountsrw      = {
    "/pipes": var.pipes_path,
  }
  volumes       = {
    // This is becoming big very fast (1GB), too big for tmfs
    "/tmp": docker_volume.tmp.name
  }
  ramdisks      = {}
}

# Volumes
resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}

# Service settings
variable "station" {
  description = "Spotify station name"
  type        = string
  default     = "Spotty Croquette"
}

variable "display_enabled" {
  description = "Enable framebuffer display"
  type        = bool
  default     = false
}

variable "spotify_id" {
  description = "Spotify Client ID (for display)"
  type        = string
  default     = ""
}

variable "spotify_secret" {
  description = "Spotify Client Secret (for display)"
  type        = string
  default     = ""
}

variable "pipes_path" {
  description = "Path for sound pipe"
  type        = string
}
