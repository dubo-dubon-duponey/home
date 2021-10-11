####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "spotify"
    image         = "dubo-dubon-duponey/spotify:bullseye-2021-10-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    // XXX Very hackish
    devices       = var.display_enabled ?  [
      "/dev/snd",
      "/dev/tty2",
      "/dev/fb0",
    ] : ["/dev/snd"]
    group_add       = var.display_enabled ?  [
      "audio",
      "tty",
      "video",
    ] : [
      "audio"
    ]
    command       = [
      "--device", "default", # as seen with librespot --name foo --device ?
      "--mixer-name", "PCM", # defaults to PCM
      "--mixer-card", "hw:0", # (from aplay -l - defaults to default)
      "--initial-volume", "75",
      "--enable-volume-normalisation",
      "-v",
    ]
    # Necessary for framebuffer output
    extra_caps  = [
      "CAP_SYS_TTY_CONFIG"
    ]
    labels        = {
    }
  }
}
