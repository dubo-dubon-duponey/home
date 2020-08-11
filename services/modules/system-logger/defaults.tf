locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "log"
    image = "${var.registry}/dubodubonduponey/filebeat:latest"
    // Custom for this image
  }
}
