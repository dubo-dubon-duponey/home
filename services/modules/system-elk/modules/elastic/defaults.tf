locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "elastic"
    image = "${var.registry}/dubodubonduponey/elastic:v1"
    // Custom for this image
  }
}
