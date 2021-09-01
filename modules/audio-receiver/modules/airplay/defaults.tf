####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "airplay"
    image         = "dubo-dubon-duponey/airplay:bullseye-2021-09-01"
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
      #"-vv",
      #"--statistics",
      "--",
      "-d",
      "hw:0",
    ]
    extra_caps  = ["NET_BIND_SERVICE"]
    labels        = {
    }
  }
}
