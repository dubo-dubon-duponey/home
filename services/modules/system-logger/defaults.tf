locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "log"
    image = "dubodubonduponey/filebeat:v1"
    // Custom for this image
  }
}
