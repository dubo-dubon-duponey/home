locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "apt-mirror"
    image = "${var.registry}/dubodubonduponey/aptly"
    // Custom for this image
  }
}
