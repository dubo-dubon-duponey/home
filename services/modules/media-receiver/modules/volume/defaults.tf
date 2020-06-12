locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "volume"
    image = "dubodubonduponey/homekit-alsa:v1"
    // Custom for this image
  }
}
