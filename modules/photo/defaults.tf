####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "photoprism"
    image         = "photoprism/photoprism:latest" // dubo-dubon-duponey/photoprism:bullseye-2021-10-15"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = [
      "photoprism",
      "start"
    ]
    extra_caps  = ["NET_BIND_SERVICE"]
    labels        = {
    }
  }
}
