locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "goproxy"
    image = "${var.registry}/dubodubonduponey/goproxy"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
