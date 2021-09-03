####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "snapcast"
    image         = "dubo-dubon-duponey/snapcast:bullseye-2021-09-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = [
    ]
    group_add     = [
    ]
    command       = [
    ]
    extra_caps  = []
    labels        = {
    }
  }
}