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

resource "gandi_zonerecord" "host-www" {
  provider    = gandi

  zone        = var.zone
  name        = "host-www"
  type        = "CNAME"
  ttl         = 300
  values      = [
    var.dyn_name,
  ]
}

