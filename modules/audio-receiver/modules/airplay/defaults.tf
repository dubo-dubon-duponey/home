####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "airplay"
    image         = "dubo-dubon-duponey/airplay:bullseye-2021-10-15"
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
    # Necessary only for goplay2
    extra_caps  = ["NET_BIND_SERVICE"]
    labels        = {}
  }
}
