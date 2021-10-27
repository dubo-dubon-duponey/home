locals {
  container_expose = {}

  env           = [
    "LOG_LEVEL=${var.log_level}",
    "XDG_DATA_HOME=/data",
    "XDG_DATA_DIRS=/data",
    "XDG_CONFIG_HOME=/tmp/config",
    "XDG_CONFIG_DIRS=/config",
    "XDG_RUNTIME_DIR=/tmp/runtime",
    "XDG_STATE_HOME=/tmp/state",
    "XDG_CACHE_HOME=/tmp/cache",

    "PORT=${var.port}",
    "POSTGRES_PASSWORD=${var.password}",
    "PGDATA=/data/pg",
  ]

  mounts        = {
  }

  mountsrw      = {
    "/data": var.data_path,
  }

  ramdisks      = {
    "/tmp": "1000000"
    "/run": "1000000"
  }

  volumes = {
  }
}

variable "port" {
  description = "Service port: this controls the port exposed if in bridge networking, or if the user is root, the port being used inside the container in all other networking modes"
  type        = number
  default     = 5432
  validation {
    condition     = var.port > 0  && var.port < 65536
    error_message = "The port must be in the range 1-65535."
  }
}

variable "data_path" {
  description = "Host path for persistent data"
  type        = string
}

variable "password" {
  description = "PG password"
  type        = string
  sensitive   = true
}
