####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "kibana"
    image         = "dubodubonduponey/kibana:bullseye-2022-05-01"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    labels        = {
      "co.elastic.logs/module": "kibana",
      "co.elastic.logs/fileset": "log",
    }
  }
}