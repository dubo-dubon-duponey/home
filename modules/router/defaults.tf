####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "router"
    image         = "dubo-dubon-duponey/router:bullseye-2021-10-15"
    privileged    = false
    read_only     = true
    restart       = "no" // always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    labels        = {
    }
  }
}
