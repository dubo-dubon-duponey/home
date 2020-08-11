locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "kibana"
    image = "${var.registry}/dubodubonduponey/kibana:latest"
    // Custom for this image
  }
}
