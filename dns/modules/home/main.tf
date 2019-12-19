########################################
# Records: hosts
########################################
resource "gandi_zonerecord" "host-A" {
  provider    = gandi

  zone        = var.zone
  name        = "@"
  type        = "A"
  ttl         = 300
  values      = [
    var.static_ip,
  ]
}

resource "gandi_zonerecord" "host-bastion" {
  provider    = gandi

  zone        = var.zone
  name        = "host-bastion"
  type        = "A"
  ttl         = 300
  values      = [
    var.static_ip,
  ]
}

resource "gandi_zonerecord" "host-home" {
  provider    = gandi

  zone        = var.zone
  name        = "host-home"
  type        = "CNAME"
  ttl         = 300
  values      = [
    var.dyn_name,
  ]
}

########################################
# Records: vanity subdomains
########################################
resource "gandi_zonerecord" "sub-dns" {
  provider    = gandi

  zone        = var.zone
  name        = "dns"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-bastion.name
  ]
}

resource "gandi_zonerecord" "sub-dev" {
  provider    = gandi

  zone        = var.zone
  name        = "dev"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-bastion.name
  ]
}

resource "gandi_zonerecord" "sub-sinema" {
  provider    = gandi

  zone        = var.zone
  name        = "sinema"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-vpn" {
  provider    = gandi

  zone        = var.zone
  name        = "vpn"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-router" {
  provider    = gandi

  zone        = var.zone
  name        = "router"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-printer" {
  provider    = gandi

  zone        = var.zone
  name        = "printer"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-monitor" {
  provider    = gandi

  zone        = var.zone
  name        = "monitor"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-lights" {
  provider    = gandi

  zone        = var.zone
  name        = "lights"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "top-home" {
  provider    = gandi

  zone        = var.zone
  name        = "home"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}
