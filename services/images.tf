######################################################
# Homebridge (legacy for dyson)
######################################################
resource "docker_image" "homebridge-dac" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.homebridge.name
  pull_triggers = [data.docker_registry_image.homebridge.sha256_digest]

  connection {
    type        = "ssh"
    user        = local.dac_fact_user
    host        = local.dac_ip
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/config/homebridge",
      "chmod g+rwx ${var.docker_config}/config/homebridge",
    ]
  }
}

######################################################
# Router
######################################################
resource "docker_image" "router" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.router.name
  pull_triggers = [data.docker_registry_image.router.sha256_digest]

  connection {
    type        = "ssh"
    user        = local.nuc_fact_user
    host        = local.nuc_ip
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/config/router",
      "mkdir -p ${var.docker_config}/data/router",
      "mkdir -p ${var.docker_config}/certs/router",
      "chmod g+rwx ${var.docker_config}/config/router",
      "chmod g+rwx ${var.docker_config}/data/router",
      "chmod g+rwx ${var.docker_config}/certs/router",
    ]
  }
}

resource "docker_image" "home-share" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.home-share.name
  pull_triggers = [data.docker_registry_image.home-share.sha256_digest]
}

resource "docker_image" "roon" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.audio-roon.name
  pull_triggers = [data.docker_registry_image.audio-roon.sha256_digest]
}

