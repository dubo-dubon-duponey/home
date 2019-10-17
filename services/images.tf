######################################################
# DNS
######################################################
resource "docker_image" "dns_nuc" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]

  connection {
    type        = "ssh"
    user        = local.nuc_fact_user
    host        = local.nuc_ip
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/certs/dns",
      "chmod g+rwx ${var.docker_config}/certs/dns",
    ]
  }
}

resource "docker_image" "dns_dac" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]

  connection {
    type        = "ssh"
    user        = local.dac_fact_user
    host        = local.dac_ip
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/certs/dns",
      "chmod g+rwx ${var.docker_config}/certs/dns",
    ]
  }
}

resource "docker_image" "dns_nig" {
  provider      = docker.nightingale
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]

  connection {
    type        = "ssh"
    user        = local.nig_fact_user
    host        = local.nig_ip
    agent       = true
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.docker_config}/certs/dns",
      "chmod g+rwx ${var.docker_config}/certs/dns",
    ]
  }
}

######################################################
# Logger
######################################################
resource "docker_image" "logger_nuc" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.logger.name
  pull_triggers = [data.docker_registry_image.logger.sha256_digest]
}

resource "docker_image" "logger_dac" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.logger.name
  pull_triggers = [data.docker_registry_image.logger.sha256_digest]
}

resource "docker_image" "logger_nig" {
  provider      = docker.nightingale
  name          = data.docker_registry_image.logger.name
  pull_triggers = [data.docker_registry_image.logger.sha256_digest]
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

######################################################
# HomeKit
######################################################
resource "docker_image" "homekit-alsa-dac" {
  provider = docker.dacodac
  name = data.docker_registry_image.homekit-alsa.name
  pull_triggers = [
    data.docker_registry_image.homekit-alsa.sha256_digest]
}

resource "docker_image" "homekit-alsa-nuc" {
  provider = docker.nucomedon
  name = data.docker_registry_image.homekit-alsa.name
  pull_triggers = [
    data.docker_registry_image.homekit-alsa.sha256_digest]
}

resource "docker_image" "homekit-alsa-nig" {
  provider = docker.nightingale
  name = data.docker_registry_image.homekit-alsa.name
  pull_triggers = [
    data.docker_registry_image.homekit-alsa.sha256_digest]
}




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
