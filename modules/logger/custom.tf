# Local indirection
locals {

  container_expose = {}

  env           = [
    "KIBANA_HOST=${var.kibana}",
    "KIBANA_USERNAME=${var.kibanaUser}",
    "KIBANA_PASSWORD=${var.kibanaPassword}",
    "ELASTICSEARCH_HOSTS=[\"${var.elastic}\"]",
    // XXX wire this proper
    "ELASTICSEARCH_USERNAME=${var.kibanaUser}",
    "ELASTICSEARCH_PASSWORD=${var.kibanaPassword}",
    "MODULES=system coredns",
    "HEALTHCHECK_URL=${local.healthcheck_url}",
  ]

  mounts        = {
    "/var/log/auth.log": "/var/log/auth.log",
    # XXX this does not work on mac (obviously?)
    "/var/log/syslog": "/var/log/syslog",
    # XXX this is going to fail dramatically if docker daemon has a custom "data-root" - FIX: parse /etc/docker/daemon.json using remote-exec to figure that out
    "/var/lib/docker/containers": "/var/lib/docker/containers",
    "/var/run/docker.sock": "/var/run/docker.sock",
    "/etc/ssl/certs/ca.pem": "/home/container/certs/ca.crt"
  }
  mountsrw      = {}
  volumes       = {
    "/data": docker_volume.data.name,
    "/certs": docker_volume.certs.name,
  }

  # Healthcheck config - XXX this is BS at this point
  healthcheck_url         = "http://${var.elastic}"
}

resource "docker_volume" "certs" {
  provider      = docker
  name          = "certs-${local.container_name}"
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

# Service specific configuration
variable "elastic" {
  description = "Elastic endpoint"
  type        = string
}

variable "kibana" {
  description = "Kibana endpoint"
  type        = string
}

variable "kibanaUser" {
  description = "Kibana username"
  type        = string
}

variable "kibanaPassword" {
  description = "Kibana password"
  type        = string
}
