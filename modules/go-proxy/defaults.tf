####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "goproxy"
    image         = "dubo-dubon-duponey/goproxy:bullseye-2021-08-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    caps_if_root  = ["NET_BIND_SERVICE"]
    port          = 4443
    labels        = {
    }
  }
}
