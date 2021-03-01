locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "airport"
    image = "${var.registry}/dubodubonduponey/shairport-sync"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}