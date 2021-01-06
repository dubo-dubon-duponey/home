locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "log"
    image = "${var.registry}/dubodubonduponey/filebeat"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
  }
}
