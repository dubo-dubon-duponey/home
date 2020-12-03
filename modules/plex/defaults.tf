locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "plex"
    image = "${var.registry}/dubodubonduponey/plex"
    // Custom for this image
  }
}
