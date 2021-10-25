####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "log"
    image         = "dubo-dubon-duponey/filebeat:bullseye-2021-10-15"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    // That covers a few of the mounts permissions - but not the docker one, which still requires root
    group_add     = [
      "adm",
      "995",
    ]
    command       = []
    extra_caps  = [
      // These two are for avahi daemon ran as user
      "CAP_CHOWN", "CAP_DAC_OVERRIDE"
    ]
    labels        = {
    }
  }
}

