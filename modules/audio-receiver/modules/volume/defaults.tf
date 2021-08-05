####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "volume"
    image         = "dubo-dubon-duponey/homekit-alsa:bullseye-2021-08-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = [
      "/dev/snd",
    ]
    group_add     = [
      "audio",
    ]
    command       = []
    caps_if_root  = []
    labels        = {
    }
  }
}
