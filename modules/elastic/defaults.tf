####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "elastic"
    image         = "dubo-dubon-duponey/elastic:bullseye-2021-06-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    // port          = 4443
    labels        = {
      "co.elastic.logs/module": "elasticsearch",
    }
  }
}
