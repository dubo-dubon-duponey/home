# Bridge network - default for all containers that
# - don't need to broadcast
# - do not have specific performance requirements
resource "docker_network" "dubo-bridge" {
  provider        = docker

  name            = "${var.prefix}-bridge"

  driver          = "bridge"

  attachable      = false
  internal        = false
  ingress         = false
  check_duplicate = true
  ipv6            = false
}

# Macvlan - for containers that broadcast, and that are not on wifi
resource "docker_network" "dubo-vlan" {
  provider        = docker

  name            = "${var.prefix}-${var.driver}"

  driver          = var.driver

  attachable      = false
  internal        = false
  ingress         = false
  check_duplicate = true
  ipv6            = false

  options         = {
    parent:     var.interface,
    ipvlan_mode:  "l2",
  }

  ipam_config {
    subnet        = var.subnet
    gateway       = var.gateway
    ip_range      = var.range
    aux_address   = var.aux_address
  }

// TODO implement auto-deploy for custom macvlan bridge to allow host communication with dns servers deployed over mac/ipvlan
/*
dmp@nucomedon:~$ cat test-network-cheat.sh
ip link del dubo-shim 2>/dev/null
ip link add dubo-shim link eno1 type macvlan mode bridge
ip addr add 10.0.4.97/24 dev dubo-shim
ip link set dubo-shim up
ip route add 10.0.4.96/31 dev dubo-shim

# https://blog.oddbit.com/post/2014-08-11-four-ways-to-connect-a-docker/

  connection {
    type      = "ssh"
    user      = var.user
    password  = var.password
    host      = var.ip
    port      = local.factory_port
    agent     = false
  }

  # Package refresh base
  provisioner "remote-exec" {
    inline = [
      "echo '>>>>>>>> Base <<<<<<<<'",
      "sudo apt-get update > /dev/null",
      "sudo apt-get dist-upgrade -y > /dev/null",
      "sudo apt-get install -y lsof > /dev/null",
      "printf '${var.hostname}\\n' | sudo tee /etc/hostname",
      "[ -d /home/${var.user}/.ssh ] || mkdir /home/${var.user}/.ssh",
      "[ \"${var.dac_disable_wifi}\" ] || sudo grep -q '${var.wifi_ssid}' /etc/wpa_supplicant/wpa_supplicant.conf || printf 'country=US\\nnetwork={\\n       ssid=\"${var.wifi_ssid}\"\\n       psk=${var.wifi_psk}\\n}\\n' | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf",
      "[ \"${var.dac_disable_wifi}\" ] || sudo wpa_cli -i wlan0 reconfigure",
    ]
  }*/
}
