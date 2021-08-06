####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Specific to http services
####################################################################

locals {
  container_expose = {}

  env           = [
    "LOG_LEVEL=${var.log_level}",

    "KIBANA_HOST=${var.kibana}",
    "KIBANA_USERNAME=${var.kibanaUser}",
    "KIBANA_PASSWORD=${var.kibanaPassword}",
    "ELASTICSEARCH_HOSTS=[\"${var.elastic}\"]",
    // XXX wire this proper
    "ELASTICSEARCH_USERNAME=${var.elasticUser}",
    "ELASTICSEARCH_PASSWORD=${var.elasticPassword}",
    "MODULES=system coredns",
    "HEALTHCHECK_URL=${var.elastic}/_cluster/health",
  ]

  mounts        = {
    "/var/log/auth.log": "/var/log/auth.log",
    # XXX this does not work on mac (obviously?)
    "/var/log/syslog": "/var/log/syslog",
    # XXX this is going to fail dramatically if docker daemon has a custom "data-root" - FIX: parse /etc/docker/daemon.json using remote-exec to figure that out
    "/var/lib/docker/containers": "/var/lib/docker/containers",
    "/var/run/docker.sock": "/var/run/docker.sock",
    // XXX generalize this
    "/etc/ssl/certs/ca.pem": "/home/container/certs/ca.crt"
  }

  // It should be possible for each important path (/data, /certs, /tmp)
  // to pick either "tmpfs", a local path, or "volume"

  mountsrw      = {}

  // Note: in case this restarts, this may duplicate logs, since files being read may be read again from the beginning
  ramdisks      = {
    "/tmp": "500000000"
  }

  volumes = {}

  # Healthcheck config - XXX this is BS at this point
  healthcheck_url         = var.elastic
}

# Service specific configuration
variable "elastic" {
  description = "Elastic endpoint"
  type        = string
}

variable "elasticUser" {
  description = "Elastic username"
  type        = string
  sensitive   = true
}

variable "elasticPassword" {
  description = "Elastic password"
  type        = string
  sensitive   = true
}

variable "kibana" {
  description = "Kibana endpoint"
  type        = string
}

variable "kibanaUser" {
  description = "Kibana username"
  type        = string
  sensitive   = true
}

variable "kibanaPassword" {
  description = "Kibana password"
  type        = string
  sensitive   = true
}
