resource "docker_container" "container" {
  provider      = docker
  image         = docker_image.image.latest

  name          = local.container_name
  hostname      = local.container_hostname
  network_mode  = local.container_network
  dns           = local.container_dns
  user          = local.container_user

  restart       = "always"
  read_only     = true

  capabilities {
    drop  = ["ALL"]
  }

  labels        = {
    "co.elastic.logs/enabled": local.log,
  }

  env           = [
    "KIBANA_HOST=${local.service_kibana}",
    "ELASTICSEARCH_HOSTS=[\"${local.service_elastic}\"]",
    "ELASTICSEARCH_USERNAME=",
    "ELASTICSEARCH_PASSWORD=",
    "MODULES=system coredns",
    "HEALTHCHECK_URL=${local.healthcheck_url}",
  ]

  volumes {
    volume_name = docker_volume.data.name
    container_path = "/data"
  }

  volumes {
    volume_name = docker_volume.certs.name
    container_path = "/certs"
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

}
