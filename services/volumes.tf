// Preserve certificates as used by the router on nuc
resource "docker_volume" "router_certs_nuc" {
  provider      = docker.nucomedon
  name          = "router_certs"
}

// Preserve data for volume controllers
resource "docker_volume" "homekit_data_dac" {
  provider      = docker.dacodac
  name          = "homekit_data"
}

resource "docker_volume" "homekit_data_nig" {
  provider      = docker.nightingale
  name          = "homekit_data"
}

// Preserve data for the remnant of homebridge
resource "docker_volume" "homebridge_data_dac" {
  provider      = docker.dacodac
  name          = "homebridge_data"
}


# TODO move all host volumes here
/*
resource "docker_volume" "dns_config_nuc" {
  provider      = docker.nucomedon
  name          = "dns_config"

  connection {
    type        = "ssh"
    user        = local.nuc_fact_user
    host        = local.nuc_ip
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/config/dns",
      "chmod g+rwx ${var.docker_config}/config/dns",
    ]
  }
}
*/
