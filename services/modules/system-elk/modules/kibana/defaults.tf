locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "kibana"
    image = "${var.registry}/dubodubonduponey/kibana:v1"
    // Custom for this image
  }
}
