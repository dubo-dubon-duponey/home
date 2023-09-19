####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "raat"
    image         = "dubodubonduponey/roon:bridge-bookworm-2023-09-05"
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
    command       = [
    ]
    extra_caps  = [
    ]
    labels        = {
    }
  }
}
