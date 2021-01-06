locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "raat"
    image = "${var.registry}/dubodubonduponey/roon-bridge"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
