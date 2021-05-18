####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "wiz"
    image         = "dubodubonduponey/homekit-wiz"
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
