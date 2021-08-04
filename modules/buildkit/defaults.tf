locals {
  defaults = {
    nickname      = "buildkit"
    image         = "dubo-dubon-duponey/buildkit:bullseye-2021-06-01"
    privileged    = true
    // XXX revert this - apparently used by apt-get cert management right now
    read_only     = false // true
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
