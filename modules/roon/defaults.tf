####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "roon"
    image         = "dubodubonduponey/roon:server-bookworm-2023-09-05"
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
