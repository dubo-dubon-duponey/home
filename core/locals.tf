# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"
# UPDATE terraform on mac now builds with CGO and it seems that mDNS names are now usable...

locals {
  // Registry to pull from
  registry        = {
    address: var.registry_address,
    username: var.registry_username,
    password: var.registry_password,
  }

  // Node specific info
  providers     = {
    nuc: {
      host      = "nucomedon.local" # "10.0.4.3"
      user      = "dmp"
    }
    nig: {
      host      = "nightingale.local" # "10.0.4.4"
      user      = "pi"
    },
    dac: {
      host      = "dacodac.local" # "10.0.4.5"
      user      = "pi"
    },
    cor: {
      host      = "corpisone.local" # "10.0.4.2"
      user      = "pi"
    }
  }

  // Topology to use to configure docker network
  gateway         = "10.0.4.1"
  subnet          = "10.0.4.1/24"

  networks      = {
    dac: {
      iface     = "wlan0"
      driver    = "ipvlan"
      range     = "10.0.4.48/28"
      aux = {
        link: "10.0.4.48",
      }
      hostname = "dacodac.local"
    },
    nig: {
      iface     = "wlan0"
      driver    = "ipvlan"
      range     = "10.0.4.64/28"
      aux       = {
        link: "10.0.4.64",
      }
      hostname  = "nightingale.local"
    },
    cor: {
      iface     = "wlan0"
      driver    = "ipvlan"
      range     = "10.0.4.80/28"
      aux = {
        link: "10.0.4.80",
      }
      hostname  = "corpisone.local"
    },
    nuc: {
      iface     = "eno1"
      driver    = "macvlan"
      range     = "10.0.4.96/27"
      aux       = {
        link: "10.0.4.96",
      }
      hostname  = "nucomedon.local"
    },
    mac: {
      iface     = ""
      driver    = "ipvlan"
      range     = "10.0.4.128/28"
      aux       = {}
      hostname  = "macarena.local"
    }
  }

  services        = {
    // XXX 1. DNS servers need static addresses (otherwise at restart we loose our DNS configuration accross the lan)
    // 2. these addresses cannot be auxed (docker would refuse to use them)
    // 3. these addresses cannot be at the start of the range (docker will use these for dynamically allocated containers)
    // -> end-up using the last ip in the range...
    dns1: "10.0.4.127",
    dns2: "10.0.4.79",
    dns3: "10.0.4.63",
    dns4: "10.0.4.95",
    dns: {
      upstream_name = var.service_dns_upstream_name
      upstream_ips  = var.service_dns_upstream_ips
      healthcheck   = "dns.healthcheck.jsboot.space"
    }
    registry: {
      username: var.service_registry_username,
      password: var.service_registry_password,
    }
  }

}
