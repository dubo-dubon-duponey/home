####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "samba"
    image         = "dubo-dubon-duponey/samba:bullseye-2021-08-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    caps_if_root  = [
      # Required to bind
      "NET_BIND_SERVICE",
      # These caps are only required for user account management
      # Ideally, that should be not granted to runtime image then
      # But instead a separate instance should operate "one-time" on the same volumes
      "CHOWN",
      "FOWNER",
      "SETUID", "SETGID",
      "DAC_OVERRIDE",
    ]
    labels        = {
    }
  }
}
