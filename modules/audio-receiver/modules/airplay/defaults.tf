####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "airplay"
    image         = "dubodubonduponey/airplay:bookworm-2023-09-05"
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
      // Required because of airplay protocol using a privileged port
      "NET_BIND_SERVICE",
    ]
    labels        = {
    }
  }
}
