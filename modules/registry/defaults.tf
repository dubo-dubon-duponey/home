locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "registry"
    image = "${var.registry}/dubodubonduponey/registry"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
