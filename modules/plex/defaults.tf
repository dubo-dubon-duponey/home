####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "plex"
    image         = "dubodubonduponey/plex:bullseye-2023-09-05"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    /*
    devices       = [
      "/dev/snd",
    ]
    group_add     = [
      "audio",
    ]
    */
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    port          = 443
    labels        = {
    }
  }
}
