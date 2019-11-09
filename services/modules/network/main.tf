# Bridge network - default for all containers that
# - don't need to broadcast
# - do not have specific performance requirements
resource "docker_network" "dubo-bridge" {
  name        = "hackbridge"
  provider    = docker

  driver      = "bridge"
}

# Macvlan - for containers that broadcast, and that are not on wifi
resource "docker_network" "dubo-vlan" {
  name        = "hackvlan"
  provider    = docker

  driver      = var.driver

  ipv6        = true

  options     = {
    parent:     var.interface,
    ipvlan_mode:  "l2",
  }

  ipam_config {
    subnet    = var.subnet
    gateway   = var.gateway
    ip_range  = var.range
  }

  ipam_config {
    subnet    = var.subnetv6
    gateway   = var.gatewayv6
//    ip_range  = var.rangev6
  }
}
