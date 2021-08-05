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
      host      = "nucomedon.local" # "10.0.4.218"
      user      = "dmp"
    }
    nig: {
      host      = "nightingale.local" # "10.0.1.6"
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
      vlan      = "dubo-macvlan",
      hostname  = "dacodac.local",
    },

    cor: {
      vlan      = "dubo-macvlan",
      hostname  = "corpisone.local",
    },

    nuc: {
      vlan      = "dubo-macvlan",
      hostname  = "nucomedon.local",
    },

    nig: {
      vlan      = "dubo-macvlan",
      hostname  = "nightingale.local",
    },

    mac: {
      vlan      = "dubo-ipvlan",
      hostname  = "macarena.local",
    },
  }

  services        = {
    // These DNS servers are purely for containers
    // XXX maybe have a separate DNS server for all ioshit?
    reserved: {
      dns_dac: "10.0.4.62", // Starts at 48
      dns_nig: "10.0.4.78", // Nig starts at 64
      dns_cor: "10.0.4.94", // 80
      dns_nuc: "10.0.4.126", // 96
      dns_mac: "172.17.0.1",
      elastic: "10.0.4.124",
      kibana: "10.0.4.125",
    }

    dns: {
      upstream_name = var.service_dns_upstream_name
      upstream_ips  = var.service_dns_upstream_ips
      healthcheck   = "dns.healthcheck.jsboot.space"
    }

    registry: {
      username      = var.push_registry_username
      bcrypt        = var.push_registry_password
    }

    apt             = {
      username: "dubodubonduponey",
      # base64 encoded bcrypt hash of the password
      bcrypt: "JDJhJDE0JFpWS2pWaENtVUVJeU9hRHZDVFUxeE9Cd3RjQjU5Y2RQaHZQZGp4Z3hJZURIYWZ1VWNZa3Bp", # actual password: aFBZBVJ6EjcFXyktok3osCeV6pc
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

    elastic: {
      username: "dubodubonduponey"
      password: "aFBZBVJ6EjcFXyktok3osCeV6pc"
      # base64 encoded bcrypt hash of the password
      bcrypt: "JDJhJDE0JFpWS2pWaENtVUVJeU9hRHZDVFUxeE9Cd3RjQjU5Y2RQaHZQZGp4Z3hJZURIYWZ1VWNZa3Bp",
    }

    kibana: {
      username: "dubodubonduponey"
      password: "aFBZBVJ6EjcFXyktok3osCeV6pc"
      # base64 encoded bcrypt hash of the password
      bcrypt: "JDJhJDE0JFpWS2pWaENtVUVJeU9hRHZDVFUxeE9Cd3RjQjU5Y2RQaHZQZGp4Z3hJZURIYWZ1VWNZa3Bp",
    }

    go: {
      username: "dubodubonduponey"
      # base64 encoded bcrypt hash of the password
      bcrypt: "JDJhJDE0JFpWS2pWaENtVUVJeU9hRHZDVFUxeE9Cd3RjQjU5Y2RQaHZQZGp4Z3hJZURIYWZ1VWNZa3Bp", # actual password: aFBZBVJ6EjcFXyktok3osCeV6pc
    }

    buildkit: {
      username: "dubodubonduponey"
      # base64 encoded bcrypt hash of the password
      bcrypt: "JDJhJDE0JFpWS2pWaENtVUVJeU9hRHZDVFUxeE9Cd3RjQjU5Y2RQaHZQZGp4Z3hJZURIYWZ1VWNZa3Bp", # actual password: aFBZBVJ6EjcFXyktok3osCeV6pc
    }

  }

  /*  nuc             = {
    // XXX mDNS at the router level?
    router_ip = "10.0.4.97"
  }
  */
}
