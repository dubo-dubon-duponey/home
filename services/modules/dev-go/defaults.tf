locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "goproxy"
    image = "${var.registry}/dubodubonduponey/goproxy:latest"
    // Custom for this image
  }
}
