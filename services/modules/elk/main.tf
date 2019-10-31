resource "docker_container" "elastic" {
  provider      = docker
  name          = local.host_elastic
  image         = docker_image.elastic.latest
  hostname      = "${local.host_elastic}.${var.hostname}"

  network_mode  = var.network

  env = [
  ]

  labels = {
    "co.elastic.logs/enabled": false,
  }

  dns           = var.dns

  # Secure it
  restart       = "always"
  read_only     = true

  capabilities {
    drop  = ["ALL"]
  }
}

resource "docker_container" "kibana" {
  provider      = docker
  name          = local.host_kibana
  image         = docker_image.kibana.latest
  hostname      = "${local.host_kibana}.${var.hostname}"

  network_mode  = var.network

  env = [
    "ELASTICSEARCH_HOSTS=[${var.xxx_elastic}:9200]"
#    "ELASTICSEARCH_HOSTS=[${docker_container.elastic.ip_address}:9200]"
  ]

  labels = {
    "co.elastic.logs/enabled": false,
  }


  dns           = var.dns

  # Secure it
  restart       = "always"
  read_only     = true

  capabilities {
    drop  = ["ALL"]
  }
}
