####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "wiz"
    image         = "dubo-dubon-duponey/homekit-wiz:bullseye-2021-08-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "udp"
    devices       = []
    group_add     = []
    command       = []
    caps_if_root  = []
    labels        = {
    }
  }
}
