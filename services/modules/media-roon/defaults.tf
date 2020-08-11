locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "roon"
    image = "${var.registry}/dubodubonduponey/roon-server:latest"
    // Custom for this image
  }
}
