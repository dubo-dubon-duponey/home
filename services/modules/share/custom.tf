# Local indirection
locals {
  capabilities  = var.user == "root" ? [
    # Required to bind on 548
    "NET_BIND_SERVICE",
    # Required by useradd to write to shadow
    "CHOWN",
    # Sed can't read /data/avahi-daemon.conf and can't write file with preserved perms
    "FOWNER",
    # Daemon timeout without returning if it can't drop
    "SETUID", "SETGID",
    # On restart, removing avahi pid file that does not belong to root
    "DAC_OVERRIDE",
    # Given afp needs to drop privileges to the connected user, we can't chroot it...
    #    "SYS_CHROOT",
  ] : []
  # Default Docker caps:
  # "CHOWN", "DAC_OVERRIDE", "FSETID", "FOWNER", "MKNOD", "NET_RAW", "SETGID", "SETUID", "SETFCAP", "SETPCAP", "NET_BIND_SERVICE", "SYS_CHROOT", "KILL", "AUDIT_WRITE"
  command       = []
  devices       = []
  env           = [
    "USERS=${local.users}",
    "PASSWORDS=${local.passwords}",
    "NAME=${var.station}",
    "AVAHI_NAME=dubo-netatalk",
  ]
  // If in bridge, and if we want to expose, which ports
  expose        = {}
  expose_type   = "tcp"
  group_add     = []
  labels        = {
  }
  mounts        = {}
  mountsrw      = {
    "/media/timemachine": "/home/volatile/timemachine",
    "/media/share": "/home/data/share",
    "/media/home": "/home/data/home",
  }
  volumes       = {
    "/data": docker_volume.data.name,
    "/etc": docker_volume.etc.name,
    "/var/log": docker_volume.log.name,
    "/run": docker_volume.run.name,
  }

  # Service config
  users                   = join(" ", var.users)
  passwords               = join(" ", var.passwords)
}

# Service specific configuration
variable "station" {
  description = "Name advertised by the service"
  type        = string
  default     = "Time Machine"
}

variable "users" {
  description = "List of user accounts"
  type        = list(string)
  default     = ["dmp"]
}

variable "passwords" {
  description = "List of user passwords"
  type        = list(string)
  default     = ["nhehehehe"]
}

variable "expose" {
  description = "Whether to expose ports (only applicable to bridge networking)"
  type        = bool
  default     = true
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}

resource "docker_volume" "etc" {
  provider      = docker
  name          = "etc-${local.container_name}"
}

resource "docker_volume" "log" {
  provider      = docker
  name          = "log-${local.container_name}"
}
