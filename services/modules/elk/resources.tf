data "docker_registry_image" "kibana" {
  name = local.image_reference_kibana
}

data "docker_registry_image" "elastic" {
  name = local.image_reference_elastic
}

resource "docker_image" "elastic" {
  provider      = docker
  name          = data.docker_registry_image.elastic.name
  pull_triggers = [data.docker_registry_image.elastic.sha256_digest]
}

resource "docker_image" "kibana" {
  provider      = docker
  name          = data.docker_registry_image.kibana.name
  pull_triggers = [data.docker_registry_image.kibana.sha256_digest]
}

resource "docker_volume" "data-elastic" {
  provider      = docker
  name          = "data-${local.container_name_elastic}"
}

resource "docker_volume" "config-elastic" {
  provider      = docker
  name          = "config-${local.container_name_elastic}"
}

resource "docker_volume" "tmp-elastic" {
  provider      = docker
  name          = "tmp-${local.container_name_elastic}"
}

resource "docker_volume" "data-kibana" {
  provider      = docker
  name          = "data-${local.container_name_kibana}"
}

resource "docker_volume" "xxx-hack-kibana" {
  provider      = docker
  name          = "xxx-hack-${local.container_name_kibana}"
}
