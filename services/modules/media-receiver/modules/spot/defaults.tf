locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "spot"
    image = "${var.registry}/dubodubonduponey/librespot:latest"
    // Custom for this image
  }
}