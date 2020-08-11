locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "airport"
    image = "${var.registry}/dubodubonduponey/shairport-sync:latest"
    // Custom for this image
  }
}
