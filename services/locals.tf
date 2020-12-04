# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
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

  networks      = {
    dac: {
      vlan: "dubo-vlan",
      hostname = "dacodac.local",
    },

    cor: {
      vlan: "dubo-vlan",
      hostname = "corpisone.local",
    },

    nuc: {
      vlan: "dubo-vlan",
      hostname = "nucomedon.local",
    },

    nig: {
      vlan: "dubo-vlan",
      hostname = "nightingale.local",
    },

    mac: {
      vlan: "dubo-vlan",
      hostname = "macarena.local",
    },
  }

  services        = {
    // XXX 1. DNS servers need static addresses (otherwise at restart we loose our DNS configuration accross the lan)
    // 2. these addresses cannot be auxed (docker would refuse to use them)
    // 3. these addresses cannot be at the start of the range (docker will use these for dynamically allocated containers)
    // -> end-up using the last ip in the range...
    // XXX move this to above in network
    dns_dac: "10.0.4.62",
    dns_nig: "10.0.4.78",
    dns_cor: "10.0.4.94",
    dns_nuc: "10.0.4.126",
    dns_mac: "172.17.0.1",

    dns: {
      upstream_name = var.service_dns_upstream_name
      upstream_ips  = var.service_dns_upstream_ips
      healthcheck   = "dns.healthcheck.jsboot.space"
    }

    registry: {
      username      = var.push_registry_username
      password      = var.push_registry_password
    }

    apt             = {
      username: "dubodubonduponey",
      # base64 encoded bcrypt hash of the password
      password: "JDJhJDE0JFpWS2pWaENtVUVJeU9hRHZDVFUxeE9Cd3RjQjU5Y2RQaHZQZGp4Z3hJZURIYWZ1VWNZa3Bp", # actual password: aFBZBVJ6EjcFXyktok3osCeV6pc
    }

    sound: {
      desk: {
        audio_name    = var.desk_name
        volume        = 100
      }
      bedroom: {
        audio_name    = var.bedroom_name
        volume        = 50
      }
      lounge: {
        audio_name    = var.lounge_name
        volume        = 100
      }
    }
  }

  // XXX kibana AND elastic should have a mDNS & Caddy front and replace / refactor this
  log             = {
    address: "monitor.jsboot.space:443",
    username: "dubodubonduponey"
    password: "2!JXk__Ci2iM_bkrGhZAxi7MHt-K66"
  }


/*  nuc             = {
    // XXX mDNS at the router level?
    router_ip = "10.0.4.97"
  }
  */
}
