####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "spot"
    image         = "dubo-dubon-duponey/librespot:bullseye-2021-08-01"
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
      "--device", "default", # as seen with librespot --name foo --device ?
      "--mixer-name", "PCM", # defaults to PCM
      "--mixer-card", "hw:0", # (from aplay -l - defaults to default)
      "--initial-volume", "75",
      "--enable-volume-normalisation",
      "-v",
    ]
    caps_if_root  = []
    labels        = {
    }
  }
}
