data "docker_registry_image" "image" {
  name = local.image_reference
}

resource "docker_image" "image" {
  provider      = docker
  name          = data.docker_registry_image.image.name
  pull_triggers = [data.docker_registry_image.image.sha256_digest]
}

resource "docker_volume" "data" {
  provider      = docker
  name          = "data-${local.container_name}"
}

resource "docker_volume" "run" {
  provider      = docker
  name          = "run-${local.container_name}"
}

resource "docker_volume" "etc" {
  provider      = docker
  name          = "etc-${local.container_name}"
}

resource "docker_volume" "log" {
  provider      = docker
  name          = "log-${local.container_name}"
}
