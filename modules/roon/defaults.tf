locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "roon"
    image = "${var.registry}/dubodubonduponey/roon-server"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
