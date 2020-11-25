# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
  gateway         = "10.0.4.1"
  subnet          = "10.0.4.1/24"

  node            = {
    iface = "eno1"
    user = "dmp"
    ip = "10.0.4.3"
    range = "10.0.4.52/28"
    hostname = "nucomedon.container"
    driver = "macvlan"

    dns_ip = "10.0.4.11"
  }

  registry        = {
    address: var.registry_address,
    username: var.registry_username,
    password: var.registry_password,
  }

  services        = {
    dns: {
      upstream_name = var.service_dns_upstream_name
      upstream_ips  = var.service_dns_upstream_ips
      healthcheck   = "nuc.dns.healthcheck.jsboot.space"
    }
    registry: {
      username: var.service_registry_username,
      password: var.service_registry_password,
    }
  }
}
