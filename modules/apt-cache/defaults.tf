locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "apt-cache"
    image = "${var.registry}/dubodubonduponey/aptutil"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
