locals {
  registry        = {
    address: var.registry_address,
    username: var.registry_username,
    password: var.registry_password,
  }

  // Node specific info
  providers     = {
    host      = "dacodac.local" # "10.0.4.5"
    user      = "dubo"
  }

  networks      = {
    iface     = "eth0"
    driver    = "macvlan"
    gateway   = "10.0.4.1"
    subnet    = "10.0.4.1/24"
    range     = "10.0.4.48/28"
    aux       = {
      link: "10.0.4.48",
    }
    hostname  = "dacodac.local",
  }

  services        = {
    mdns_nss: var.mdns_nss

    // One (backup) lan DNS, one containers DNS
    reserved: {
      dns: "10.0.4.62",
      dns_lan: "10.0.4.63",
    }

    dns: {
      upstream_name = var.service_dns_upstream_name
      upstream_ips  = var.service_dns_upstream_ips
      healthcheck   = "dns.healthcheck.jsboot.space"
    }

    sound: {
      audio_name    = var.service_audio_name
      volume        = var.service_audio_volume
      device        = var.service_audio_device
      mixer         = var.service_audio_mixer
      master        = var.service_master
    }
  }
}
