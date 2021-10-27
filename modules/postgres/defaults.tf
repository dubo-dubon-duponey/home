####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "postgres"
    image         = "library/postgres:9.6-bullseye" // dubo-dubon-duponey/postgres:bullseye-2021-10-15
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    // XXX Not clear why, but otherwise the container gets replaced every run
    command       = [
      "postgres"
    ]
    extra_caps  = [
      // Not clear if we can restrict further or not
      "CAP_CHOWN", "CAP_DAC_OVERRIDE",
      "SETUID", "SETGID",
    ]
    port          = 5432
    labels        = {
    }
  }
}
