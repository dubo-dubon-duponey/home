locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "buildkit"
    image = "${var.registry}/dubodubonduponey/buildkit"
    // Custom for this image
    privileged = true
    read_only   = true
    restart     = "always"
  }
}
