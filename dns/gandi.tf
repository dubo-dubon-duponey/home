# XXX gandi provider cannot destroy - to workaround, increment the number and manually remove with:
# APIKEY=XXX; curl -X DELETE -H "X-Api-Key: $APIKEY" https://dns.api.gandi.net/api/v5/zones/$(curl -H "X-Api-Key: $APIKEY" https://dns.api.gandi.net/api/v5/zones | jq -rc '.[] | select(.name == "${var.domain} terraform zone") | .uuid')
resource "gandi_zone" "domain" {
  name        = "${var.domain} zone terraform"
}

########################################
# Records: hosts
########################################
resource "gandi_zonerecord" "host-A" {
  zone        = gandi_zone.domain.id
  name        = "@"
  type        = "A"
  ttl         = 300
  values      = [
    var.static_bastion,
  ]
}

resource "gandi_zonerecord" "host-bastion" {
  zone        = gandi_zone.domain.id
  name        = var.subdomain_bastion
  type        = "A"
  ttl         = 300
  values      = [
    var.static_bastion,
  ]
}

resource "gandi_zonerecord" "host-home" {
  zone        = gandi_zone.domain.id
  name        = var.subdomain_home
  type        = "CNAME"
  ttl         = 300
  values      = [
    var.dyn_home,
  ]
}

########################################
# Records: vanity subdomains
########################################
resource "gandi_zonerecord" "sub-dns" {
  zone        = gandi_zone.domain.id
  name        = "dns"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-bastion.name
  ]
}

resource "gandi_zonerecord" "sub-sinema" {
  zone        = gandi_zone.domain.id
  name        = "sinema"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-vpn" {
  zone        = gandi_zone.domain.id
  name        = "vpn"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

resource "gandi_zonerecord" "sub-router" {
  zone        = gandi_zone.domain.id
  name        = "router"
  type        = "CNAME"
  ttl         = 300
  values      = [
    gandi_zonerecord.host-home.name
  ]
}

########################################
# Records: proton
########################################
resource "gandi_zonerecord" "sub-MX" {
  zone        = gandi_zone.domain.id
  name        = "@"
  type        = "MX"
  ttl         = 300
  values      = [
    "10 mail.protonmail.ch.",
    "20 mailsec.protonmail.ch.",
  ]
}

resource "gandi_zonerecord" "sub-TXT" {
  zone        = gandi_zone.domain.id
  name        = "@"
  type        = "TXT"
  ttl         = 300
  values      = [
    "protonmail-verification=a1a72217157cb524b1fbabdfe310969f86db2a12",
    "v=spf1 include:_spf.protonmail.ch mx ~all",
  ]
}

resource "gandi_zonerecord" "sub-_dmarc" {
  zone        = gandi_zone.domain.id
  name        = "_dmarc"
  type        = "TXT"
  ttl         = 300
  values      = [
    "v=DMARC1; p=none; rua=mailto:dmp42+dmarc@pm.me",
  ]
}

resource "gandi_zonerecord" "sub-protonmail" {
  zone        = gandi_zone.domain.id
  name        = "protonmail._domainkey"
  type        = "TXT"
  ttl         = 300
  values      = [
    "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQD5FNwe/taYmPvFo2UeGkNVO79jPYxNqfiFV2KklcaXX7H11nAAO/CPujzSzVl2GpVCJBRyOPas96b30VRwYmn3lYu5ziav+nr+21TTuCupdRlXfjz7Tm7jefzK88JRyDYPz9KO/Raz8/RTr2cCRCzN8voUNes9gt84o4CKWnujzwIDAQAB",
  ]
}

########################################
# Records: attach
########################################
# XXX this is buggy - destroy doesn't seem to work for eg
resource "gandi_domainattachment" "attachment" {
  domain      = var.domain
  zone        = gandi_zone.domain.id
}
