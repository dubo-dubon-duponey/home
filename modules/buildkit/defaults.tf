locals {
  defaults = {
    nickname      = "buildkit"
    // This has served us quite well
    // image         = "dubo-dubon-duponey/buildkit:bullseye-2021-06-01"
    image         = "dubo-dubon-duponey/buildkit:bullseye-2021-09-01"
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
