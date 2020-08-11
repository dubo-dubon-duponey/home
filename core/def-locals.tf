# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
  gateway         = "10.0.4.1"
  subnet          = "10.0.4.1/24"

  # This is not ready to fly - we need a dependency on core services (dns & registry) as a preflight for any of this to work
  # Alternatively, a registry proxy cache for hub would be nice
#  registry        = "registry.dev.jsboot.space"
  registry        = {
    address: "registry.dev.jsboot.space",
    username: "dubodubonduponey",
    password: "aFBZBVJ6EjcFXyktok3osCeV6pc",
    #address: "index.docker.io",
    #username: "dubodubonduponey",
    #password: "8kfpUIkZvpvQ768I,iu'zB'W>VQ6+A",
  }

  dns             = {
    upstream_name = var.dns_upstream_name
    upstream_ips = var.dns_upstream_ips
  }

  nuc             = {
    iface = "eno1"
    user = "dmp"
    ip = "10.0.4.3"
    range = "10.0.4.52/28"
    hostname = "nucomedon.container"

    dns_ip = "10.0.4.11"
    router_ip = "10.0.4.14"
  }
}
