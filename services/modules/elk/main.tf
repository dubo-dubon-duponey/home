resource "docker_container" "elastic" {
  provider      = docker
  image         = docker_image.elastic.latest

  name          = local.container_name_elastic
  hostname      = local.container_hostname_elastic
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
    "co.elastic.logs/module": "elasticsearch",
  }

  volumes {
    volume_name = docker_volume.data-elastic.name
    container_path = "/data"
  }

  volumes {
    volume_name = docker_volume.config-elastic.name
    container_path = "/config"
  }

  volumes {
    volume_name = docker_volume.tmp-elastic.name
    container_path = "/tmp"
  }

  env = [
  ]
}

resource "docker_container" "kibana" {
  provider      = docker
  image         = docker_image.kibana.latest

  name          = local.container_name_kibana
  hostname      = local.container_hostname_kibana
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
    "co.elastic.logs/module": "kibana",
    "co.elastic.logs/fileset": "log",
  }

  volumes {
    volume_name = docker_volume.data-kibana.name
    container_path = "/data"
  }

  volumes {
    volume_name = docker_volume.xxx-hack-kibana.name
    container_path = "/boot/optimize"
  }

  env = [
    "SERVER_HOST=${local.container_hostname_kibana}",
    "SERVER_NAME=${local.container_hostname_kibana}",
    "ELASTICSEARCH_HOSTS=http://${docker_container.elastic.ip_address}:9200",
    "HEALTHCHECK_URL=http://${local.container_hostname_kibana}:5601/api/status?healthcheck",
  ]

  # XXX It seems that docker_container.elastic.ip_address is racy...
  #depends_on = [
  #  docker_container.elastic
  #]
}



