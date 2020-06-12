locals {
  defaults = {
    // Defaults to apply if no variable is passed for these
    nickname = "dns"
    image = "dubodubonduponey/coredns:v1"
    // Custom for this image
    // Upstream DNS to use
    upstream_name = "cloudflare-dns.com"
    upstream_ips = [
      "1.1.1.1",
      "1.0.0.1",
    ]
  }
}
