####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "airport"
    image         = "dubo-dubon-duponey/shairport-sync:bullseye-2021-08-01"
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
    command       = [
      "-vv",
      "--statistics",
      "--",
      "-d",
      "hw:0",
    ]
    caps_if_root  = []
    labels        = {
    }
  }
}

/*
nickname      = "elastic"
image         = "dubo-dubon-duponey/elastic:bullseye-2021-06-01"
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
  "co.elastic.logs/module": "elasticsearch",
}
*/
