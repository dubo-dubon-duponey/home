locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "wiz"
    image = "${var.registry}/dubodubonduponey/homekit-wiz"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
