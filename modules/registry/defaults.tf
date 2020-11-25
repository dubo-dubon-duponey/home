locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "registry"
    image = "${var.registry}/dubodubonduponey/registry:latest"
    // Custom for this image
  }
}
