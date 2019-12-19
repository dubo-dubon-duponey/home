variable "image" {
  description = "Image reference"
  type        = string
  default     = "dubodubonduponey/netatalk:v1"
}

variable "nickname" {
  description = "Nickname for the service"
  type        = string
  default     = "nick"
}

variable "hostname" {
  description = "Base hostname for the node"
  type        = string
  default     = "mynode.local"
}

variable "privileged" {
  description = "Whether we grant privileges to this container"
  type        = bool
  default     = false
}

variable "user" {
  description = "User to run the container with, if not privileged"
  type        = string
  default     = ""
}

variable "log" {
  description = "Whether to flag for filebeat log collection or not"
  type        = bool
  default     = false
}

variable "network" {
  description = "Network name"
  type        = string
  default     = "hack-net"
}

variable "dns" {
  description = "DNS server ip to use for this container"
  type        = list(string)
  default     = []
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

# Local indirection
locals {
  # Image config
  image_reference         = var.image

  # Container config
  container_name          = var.nickname
  container_hostname      = "${var.nickname}.${var.hostname}"
  container_network       = var.network
  container_capabilities  = var.privileged ? [
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

  container_user          = var.privileged ? "root" : var.user
  container_dns           = var.dns

  # Logger
  log                     = var.log

  # Service config
  # Service config
  station                 = var.station
  users                   = join(" ", var.users)
  passwords               = join(" ", var.passwords)

}
