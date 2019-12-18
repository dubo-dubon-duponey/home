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
    add   = local.container_capabilities
  }

  labels        = {
    "co.elastic.logs/enabled": local.log,
    "co.elastic.logs/module": "coredns",
    "co.elastic.logs/fileset": "log",
  }

  volumes {
    volume_name = docker_volume.certs.name
    container_path = "/certs"
  }

  env = [
    "DOMAIN=",
    "EMAIL=",
    "UPSTREAM_SERVER_1=${local.dns_upstream_1}",
    "UPSTREAM_SERVER_2=${local.dns_upstream_2}",
    "UPSTREAM_NAME=${local.dns_upstream_name}",
    "STAGING=",
    "DNS_PORT=${local.dns_port}",
    "TLS_PORT=1853",
    "HTTPS_PORT=1443",
    "GRPC_PORT=5553",
    "METRICS_PORT=9253",
    "HEALTHCHECK_URL=127.0.0.1:${local.dns_port}",
    "HEALTHCHECK_QUESTION=${local.healthcheck_question}",
    "HEALTHCHECK_TYPE=udp",
  ]

  # Regular DNS service
  ports {
    internal    = local.dns_port
    external    = 53
    protocol    = "udp"
  }
}
