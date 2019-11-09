#####################################################
# Zones
#####################################################
resource "gandi_zone" "jsboot-net" {
  name        = "jsboot.net zone terraform 3"
}

resource "gandi_zone" "jsboot-com" {
  name        = "jsboot.com zone terraform"
}

resource "gandi_zone" "farcloser-world" {
  name        = "farcloser.world zone terraform 2"
}

resource "gandi_zone" "loop-dev-com" {
  name        = "loop-dev.com zone terraform"
}

resource "gandi_zone" "webitup-fr" {
  name        = "webitup.fr zone terraform 2"
}

/*
resource "gandi_zone" "lacunar-org" {
  name        = "lacunar.org zone terraform"
}
*/

resource "gandi_zone" "jsboot-space" {
  name        = "jsboot.space zone terraform"
}

resource "gandi_zone" "gambier-email" {
  name        = "gambier.email zone terraform"
}

#####################################################
# Attach
#####################################################
resource "gandi_domainattachment" "jsboot-net" {
  domain      = "jsboot.net"
  zone        = gandi_zone.jsboot-net.id
}

resource "gandi_domainattachment" "jsboot-com" {
  domain      = "jsboot.com"
  zone        = gandi_zone.jsboot-com.id
}

resource "gandi_domainattachment" "farcloser-world" {
  domain      = "farcloser.world"
  zone        = gandi_zone.farcloser-world.id
}

resource "gandi_domainattachment" "loop-dev-com" {
  domain      = "loop-dev.com"
  zone        = gandi_zone.loop-dev-com.id
}

resource "gandi_domainattachment" "webitup-fr" {
  domain      = "webitup.fr"
  zone        = gandi_zone.webitup-fr.id
}

resource "gandi_domainattachment" "jsboot-space" {
  domain      = "jsboot.space"
  zone        = gandi_zone.jsboot-space.id
}

resource "gandi_domainattachment" "gambier-email" {
  domain      = "gambier.email"
  zone        = gandi_zone.gambier-email.id
}
