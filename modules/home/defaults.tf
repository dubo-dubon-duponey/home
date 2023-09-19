####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "home"
    image         = "homeassistant/home-assistant:2023.8" // 2023.3" // 2022.11"
    privileged    = false
    // XXX trying to get flair to install - specifying a custom HOME env make it that install flow can't find the plugin - so, making /root writable (mounting would be better)
    // true
    read_only     = false
    restart       = "always"
    expose_type   = "tcp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = [
      "NET_BIND_SERVICE",
      // Necessary to capture dhcp requests
      "CAP_NET_RAW",
    ]
    labels        = {
    }
  }
}

// docker run --rm --init -d   --name homeassistant -v /etc/localtime:/etc/localtime:ro   -v $(pwd)/home-assistant:/config  --network=host homeassistant/home-assistant:stable
