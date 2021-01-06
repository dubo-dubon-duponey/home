locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "dns"
    image = "${var.registry}/dubodubonduponey/coredns"
    // Custom for this image
    privileged  = false
    read_only   = true
    restart     = "always"
    // Upstream DNS to use
    upstream_name = "cloudflare-dns.com"
    upstream_ips = [
      "1.1.1.1",
      "1.0.0.1",
    ]
  }
}
