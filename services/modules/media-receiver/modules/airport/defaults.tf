locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "airport"
    image = "${var.registry}/dubodubonduponey/shairport-sync:v1"
    // Custom for this image
  }
}
