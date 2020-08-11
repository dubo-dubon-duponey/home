locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "raat"
    image = "${var.registry}/dubodubonduponey/roon-bridge:latest"
    // Custom for this image
  }
}
