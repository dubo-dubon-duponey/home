locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "volume"
    image = "${var.registry}/dubodubonduponey/homekit-alsa"
    // Custom for this image
  }
}
