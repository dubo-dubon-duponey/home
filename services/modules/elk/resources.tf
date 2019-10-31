data "docker_registry_image" "kibana" {
  name = local.image_kibana
}

data "docker_registry_image" "elastic" {
  name = local.image_elastic
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
