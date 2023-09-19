####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "snapcast"
    image         = "dubodubonduponey/snapcast:bookworm-2023-09-05"
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
      // These two are for avahi daemon ran as user
      "CAP_CHOWN", "CAP_DAC_OVERRIDE"
    ]
    labels        = {
    }
  }
}
