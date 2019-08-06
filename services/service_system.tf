# Images
resource "docker_image" "system-letsencrypt" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.system-letsencrypt.name
  pull_triggers = [data.docker_registry_image.system-letsencrypt.sha256_digest]
}

resource "docker_image" "log-nuc" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.system-log.name
  pull_triggers = [data.docker_registry_image.system-log.sha256_digest]
}

resource "docker_image" "log-dac" {
  provider      = docker.dacodac
  name          = data.docker_registry_image.system-log.name
  pull_triggers = [data.docker_registry_image.system-log.sha256_digest]
}

resource "docker_image" "log-nig" {
  provider      = docker.nightingale
  name          = data.docker_registry_image.system-log.name
  pull_triggers = [data.docker_registry_image.system-log.sha256_digest]
}

# Containers
resource "docker_container" "system-letsencrypt" {
  provider  = docker.nucomedon
  name      = "letsencrypt"
  image     = docker_image.system-letsencrypt.latest

  restart   = "always"
  network_mode = "host"

  env = [
    "PUID=${local.nuc_puid}",
    "PGID=${local.nuc_pgid}",
    "URL=${var.domain}",
    "SUBDOMAINS=${var.subs}",
    "STAGING=true",
    "ONLY_SUBDOMAINS=true",
    "EMAIL=${var.email}"
  ]

  mounts {
    target  = "/config"
    source  = "/home/data/config/router"
    read_only = false
    type    = "bind"
  }

  # Required by fail2ban to tweak iptables
  capabilities {
    add  = ["NET_ADMIN"]
  }
}

resource "docker_container" "log-nucomedon" {
  provider  = docker.nucomedon
  name      = "log"
  image     = docker_image.log-nuc.latest
  restart   = "always"

  env = [
    "LOGDNA_KEY=${var.logdna-key}}",
    "FILTER_NAME=letsencrypt share roon bridge airport raat"
  ]

  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    read_only = false
    type      = "bind"
  }
}

resource "docker_container" "log-dacodac" {
  provider  = docker.dacodac
  name      = "log"
  image     = docker_image.log-dac.latest
  restart   = "always"

  env = [
    "LOGDNA_KEY=${var.logdna-key}}",
    "FILTER_NAME=letsencrypt share roon bridge airport raat"
  ]

  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    read_only = false
    type      = "bind"
  }
}

resource "docker_container" "log-nightingale" {
  provider  = docker.nightingale
  name      = "log"
  image     = docker_image.log-nig.latest
  restart   = "always"

  env = [
    "LOGDNA_KEY=${var.logdna-key}}",
    "FILTER_NAME=letsencrypt share roon bridge airport raat"
  ]

  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    read_only = false
    type      = "bind"
  }
}
