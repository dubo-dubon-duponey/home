# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
  gateway         = "10.0.4.1"
  subnet          = "10.0.4.1/24"

  mac             = {
    hostname = "macarena.container"
    dns_ip = "172.17.0.1"
  }

  cor             = {
    iface = "eth0"
    range = "10.0.4.20/28"
    user = "pi"
    ip = "10.0.4.2"
    hostname = "corpisone.container"

    dns_ip = "10.0.4.10"

    audio_name    = var.cor_audio_name
    hw_index      = 1
    mixer_name    = "PCM"
    card_name     = "Mojo"
    volume        = 100
  }

  nuc             = {
    iface = "eno1"
    range = "10.0.4.52/28"
    user = "dmp"
    ip = "10.0.4.3"
    hostname = "nucomedon.container"

    dns_ip = "10.0.4.11"
    router_ip = "10.0.4.14"
  }

  nig             = {
    iface = "wlan0"
    range = "10.0.4.116/28"
    user = "pi"
    ip = "10.0.4.4"
    hostname = "nightingale.container"

    dns_ip = "10.0.4.13"

    audio_name    = var.nig_audio_name
    hw_index      = 0
    mixer_name    = "Digital"
    card_name     = "sndrpihifiberry"
    volume        = 50

    /*
    hw_index      = 1
    mixer_name    = "PCM"
    card_name     = "DACE17,DEV=1"
    volume        = 100
    */
  }

  dac             = {
    iface = "wlan0"
    range = "10.0.4.84/28"
    user = "pi"
    ip = "10.0.4.8"
    hostname = "dacodac.container"

    dns_ip = "10.0.4.12"

    audio_name    = var.dac_audio_name
    #hw_index      = 0
    #mixer_name    = "Digital"
    #card_name     = "sndrpihifiberry"
    hw_index      = 1
    mixer_name    = "PCM"
    card_name     = "Qutest"
    volume        = 100
  }

  dns             = {
    upstream_name = var.dns_upstream_name
    upstream_ips = var.dns_upstream_ips
  }
}
