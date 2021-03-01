locals {
  defaults = {
    nickname      = "buildkit"
    image         = "dubodubonduponey/buildkit"
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
