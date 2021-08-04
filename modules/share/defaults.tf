####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "afp"
    image         = "dubo-dubon-duponey/netatalk:bullseye-2021-06-01"
    privileged    = false
    // XXX why oh why
    read_only     = false
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    # Default Docker caps:
    # "CHOWN", "DAC_OVERRIDE", "FSETID", "FOWNER", "MKNOD", "NET_RAW", "SETGID", "SETUID", "SETFCAP", "SETPCAP", "NET_BIND_SERVICE", "SYS_CHROOT", "KILL", "AUDIT_WRITE"
    caps_if_root  = [
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
    ]
    labels        = {
    }
  }
}
