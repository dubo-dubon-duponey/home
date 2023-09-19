####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "spotify"
    image         = "dubodubonduponey/spotify:bookworm-2023-09-05"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    // XXX experimental fbi support for embedded display
    devices       = var.display_enabled ?  [
      "/dev/snd",
      "/dev/tty2",
      "/dev/fb0",
    ] : [
      "/dev/snd"
    ]
    // XXX experimental fbi support for embedded display
    group_add       = var.display_enabled ?  [
      "audio",
      "tty",
      "video",
    ] : [
      "audio"
    ]
    command       = [
      // "--device", "default", # as seen from: `librespot --name foo --device ?`
      /*
      "--alsa-mixer-control", "PCM", # defaults to PCM
      "--alsa-mixer-device", "hw:0", # (from: aplay -l - defaults to default)
      */
      "--initial-volume", "75",
      "--enable-volume-normalisation",
    ]
    // XXX experimental fbi support for embedded display
    extra_caps  = var.display_enabled ?  [
      "CAP_SYS_TTY_CONFIG"
    ] : [
    ]
    labels        = {
    }
  }
}
