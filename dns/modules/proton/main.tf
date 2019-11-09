resource "gandi_zonerecord" "MX" {
  provider    = gandi

  zone        = var.zone
  name        = "@"
  type        = "MX"
  ttl         = 1800
  values      = [
    "10 mail.protonmail.ch.",
    "20 mailsec.protonmail.ch.",
  ]
}

resource "gandi_zonerecord" "verification" {
  provider    = gandi

  zone        = var.zone
  name        = "@"
  type        = "TXT"
  ttl         = 300
  values      = [
    "protonmail-verification=${var.verification}",
    "v=spf1 include:_spf.protonmail.ch mx ~all",
  ]
}

resource "gandi_zonerecord" "dmarc" {
  provider    = gandi

  zone        = var.zone
  name        = "_dmarc"
  type        = "TXT"
  ttl         = 300
  values      = [
    "v=DMARC1; p=none; rua=mailto:dmp42+dmarc@pm.me",
  ]
}

resource "gandi_zonerecord" "dkim" {
  provider    = gandi

  zone        = var.zone
  name        = "protonmail._domainkey"
  type        = "TXT"
  ttl         = 300
  values      = [
    "v=DKIM1; k=rsa; p=${var.domainkey}",
  ]
}
