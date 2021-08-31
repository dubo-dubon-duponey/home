locals {
  defaults = {
    nickname      = "buildkit"
    image         = "dubo-dubon-duponey/buildkit:bullseye-2021-06-01"
    privileged    = true
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    // port          = 4443
    labels        = {
    }
  }
}
