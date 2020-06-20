locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "router"
    image = "${var.registry}/dubodubonduponey/caddy:v1"
    // Custom for this image
  }
}
