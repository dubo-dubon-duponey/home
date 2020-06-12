locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "apt"
    image = "${var.registry}/dubodubonduponey/aptutil:v1"
    // Custom for this image
  }
}
