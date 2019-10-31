data "docker_registry_image" "logger" {
  name = local.image
}

resource "docker_image" "logger" {
  provider      = docker
  name          = data.docker_registry_image.logger.name
  pull_triggers = [data.docker_registry_image.logger.sha256_digest]
}
