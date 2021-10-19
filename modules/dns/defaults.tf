####################################################################
# Default values for this container
# Some values can be overridden with variables (image name, nickname, port)
####################################################################

locals {
  defaults = {
    nickname      = "dns"
    image         = "dubo-dubon-duponey/dns:bullseye-2021-10-15"
    privileged    = false
    read_only     = true
    restart       = "always"
    expose_type   = "udp"
    devices       = []
    group_add     = []
    command       = []
    extra_caps  = ["NET_BIND_SERVICE"]
    port          = 53
    labels        = {
      "co.elastic.logs/module": "coredns",
      "co.elastic.logs/fileset": "log",
    }

    // Upstream DNS to use
    upstream_name = "cloudflare-dns.com"
    upstream_ips = [
      "1.1.1.1",
      "1.0.0.1",
    ]
  }
}
