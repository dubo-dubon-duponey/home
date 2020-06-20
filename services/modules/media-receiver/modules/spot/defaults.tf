locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "spot"
    image = "${var.registry}/dubodubonduponey/librespot:v1"
    // Custom for this image
  }
}
