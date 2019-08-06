
resource "docker_network" "dac_hackvlan" {
  name      = "hackvlan"
  provider  = docker.dacodac

  driver = "macvlan"
  options = {
    parent: local.dac_fact_iface,
  }
  ipam_config {
    subnet = local.subnet
    gateway = local.gateway
    ip_range = local.dac_range
  }
}

resource "docker_network" "nuc_hackvlan" {
  name      = "hackvlan"
  provider  = docker.nucomedon

  driver = "macvlan"
  options = {
    parent: local.nuc_fact_iface,
  }
  ipam_config {
    subnet = local.subnet
    gateway = local.gateway
    ip_range = local.nuc_range
  }
}

# XXX macvlan will not work over wifi - short of setting-up trunk networking + ipvlan... fuck it
resource "docker_network" "nig_hackvlan" {
  name      = "hackvlan"
  provider  = docker.nightingale

  driver = "macvlan"
  options = {
    parent: local.nig_fact_iface,
    ipvlan_mode: "l2",
  }
  ipam_config {
    subnet = local.subnet
    gateway = local.gateway
    ip_range = local.nig_range
  }
}
