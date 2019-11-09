#####################################################
# Proton
#####################################################
module "mail-jsboot-net" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.jsboot-net.id
  verification      = var.jsboot-net-verification
  domainkey         = var.jsboot-net-domainkey
  email             = var.dmarc-email
}

module "mail-jsboot-com" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.jsboot-com.id
  verification      = var.jsboot-com-verification
  domainkey         = var.jsboot-com-domainkey
  email             = var.dmarc-email
}

module "mail-farcloser-world" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.farcloser-world.id
  verification      = var.farcloser-world-verification
  domainkey         = var.farcloser-world-domainkey
  email             = var.dmarc-email
}

module "mail-loop-dev-com" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.loop-dev-com.id
  verification      = var.loop-dev-com-verification
  domainkey         = var.loop-dev-com-domainkey
  email             = var.dmarc-email
}

module "mail-webitup-fr" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.webitup-fr.id
  verification      = var.webitup-fr-verification
  domainkey         = var.webitup-fr-domainkey
  email             = var.dmarc-email
}

module "mail-jsboot-space" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.jsboot-space.id
  verification      = var.jsboot-space-verification
  domainkey         = var.jsboot-space-domainkey
  email             = var.dmarc-email
}

module "mail-gambier-email" {
  source            = "./modules/proton"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.gambier-email.id
  verification      = var.gambier-email-verification
  domainkey         = var.gambier-email-domainkey
  email             = var.dmarc-email
}

#####################################################
# Routing
#####################################################
module "home-farcloser-world" {
  source            = "./modules/home"
  providers         = {
    gandi  = gandi
  }

  zone              = gandi_zone.farcloser-world.id
  static_ip         = var.static-ip
  dyn_name          = var.dyn-name
}
