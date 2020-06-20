locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "wiz"
    image = "${var.registry}/dubodubonduponey/homekit-wiz:latest"
    // Custom for this image
  }
}
