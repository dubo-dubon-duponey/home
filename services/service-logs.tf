resource "docker_container" "logger_nuc" {
  provider      = docker.nucomedon
  name          = "logger"
  image         = docker_image.logger_nuc.latest
  hostname      = "log.nucomedon.container"

  network_mode  = docker_network.nuc_bridge.name
  user          = "root"

  env           = [
    "ELASTICSEARCH_HOSTS=[\"${local.nuc_ip}:9200\"]",
    "KIBANA_HOST=${local.nuc_ip}:5601",
    "HEALTHCHECK_URL=http://${local.nuc_ip}:9200",
    "MODULES=coredns system",
  ]

  labels        = {
    "co.elastic.logs/enabled": false,
  }

  mounts {
    target      = "/var/lib/docker/containers"
    source      = "/var/lib/docker/containers"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/run/docker.sock"
    source      = "/var/run/docker.sock"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/syslog"
    source      = "/var/log/syslog"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/auth.log"
    source      = "/var/log/auth.log"
    read_only   = true
    type        = "bind"
  }

  # DNS config and dependencies
  /*
  depends_on    = [
    docker_container.dns_nuc
  ]
  dns           = [docker_container.dns_nuc.ip_address]
  */

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
}

resource "docker_container" "logger_dac" {
  provider      = docker.dacodac
  name          = "logger"
  image         = docker_image.logger_dac.latest
  hostname      = "log.dacodac.container"

  network_mode  = "bridge"
  user          = "root"

  env           = [
    "ELASTICSEARCH_HOSTS=[\"${local.nuc_ip}:9200\"]",
    "KIBANA_HOST=${local.nuc_ip}:5601",
    "MODULES=coredns system",
  ]

  labels        = {
    "co.elastic.logs/enabled": false,
  }

  mounts {
    target      = "/var/lib/docker/containers"
    source      = "/var/lib/docker/containers"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/run/docker.sock"
    source      = "/var/run/docker.sock"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/syslog"
    source      = "/var/log/syslog"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/auth.log"
    source      = "/var/log/auth.log"
    read_only   = true
    type        = "bind"
  }

  # DNS config and dependencies
  /*
  depends_on    = [
    docker_container.dns_dac
  ]
  dns           = ["172.17.0.1"]
  */

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
}


resource "docker_container" "logger_nig" {
  provider      = docker.nightingale
  name          = "logger"
  image         = docker_image.logger_nig.latest
  hostname      = "log.nightingale.container"

  network_mode  = "bridge"
  user          = "root"

  env           = [
    "ELASTICSEARCH_HOSTS=[\"${local.nuc_ip}:9200\"]",
    "KIBANA_HOST=${local.nuc_ip}:5601",
    "MODULES=coredns system",
  ]

  labels        = {
    "co.elastic.logs/enabled": false,
  }

  mounts {
    target      = "/var/lib/docker/containers"
    source      = "/var/lib/docker/containers"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/run/docker.sock"
    source      = "/var/run/docker.sock"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/syslog"
    source      = "/var/log/syslog"
    read_only   = true
    type        = "bind"
  }

  mounts {
    target      = "/var/log/auth.log"
    source      = "/var/log/auth.log"
    read_only   = true
    type        = "bind"
  }

  # DNS config and dependencies
  /*
  depends_on    = [
    docker_container.dns_nig
  ]
  dns           = ["172.17.0.1"]
  */

  # Secure it
  restart       = "always"
  read_only     = true
  capabilities {
    drop        = ["ALL"]
  }
}














# docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk sebp/elk


# Home services
data "docker_registry_image" "logs-central" {
  name = "sebp/elk:740"
}

resource "docker_image" "logs-central" {
  provider      = docker.nucomedon
  name          = data.docker_registry_image.logs-central.name
  pull_triggers = [data.docker_registry_image.logs-central.sha256_digest]
}

resource "docker_container" "logs-central" {
  provider      = docker.nucomedon
  name          = "logs-central"
  image         = docker_image.logs-central.latest

  restart       = "always"

  network_mode  = "bridge"

  env = [
    "DOMAIN=",
  ]

  labels = {
    "co.elastic.logs/enabled": false,
  }

  /*
    capabilities {
      drop = ["ALL"]
    }
  */

  ports {
    internal    = 5601
    external    = 5601
    protocol    = "tcp"
  }

  ports {
    internal    = 9200
    external    = 9200
    protocol    = "tcp"
  }

  ports {
    internal    = 5044
    external    = 5044
    protocol    = "tcp"
  }

  /*
  mounts {
    target      = "/config"
    source      = "${var.docker_config}/config/dns"
    read_only   = false
    type        = "bind"
  }
*/
}
