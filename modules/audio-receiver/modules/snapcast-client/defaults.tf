####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "snapcast"
    image         = "dubo-dubon-duponey/snapcast:bullseye-2021-10-01"
    privileged    = false
    read_only     = false
    restart       = "always"
    expose_type   = "tcp"
    devices       = [
      "/dev/snd",
    ]
    group_add     = [
      "audio",
    ]
    command       = [
    ]
    extra_caps  = []
    labels        = {
    }
  }
}
