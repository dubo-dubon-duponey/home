locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "apt"
    image = "${var.registry}/dubodubonduponey/aptutil:latest"
    // Custom for this image
  }
}
