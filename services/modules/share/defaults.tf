locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "afp"
    image = "${var.registry}/dubodubonduponey/netatalk:v1"
    // Custom for this image
  }
}
