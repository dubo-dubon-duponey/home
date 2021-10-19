####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "plex"
    image         = "dubo-dubon-duponey/plex:bullseye-2021-10-15"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    port          = 443
    labels        = {
    }
  }
}
