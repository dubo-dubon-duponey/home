locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "afp"
    image = "${var.registry}/dubodubonduponey/netatalk"
    // Custom for this image
    privileged  = false
    read_only   = false
    restart     = "always"
  }
}
