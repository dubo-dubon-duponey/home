resource "docker_image" "dns" {
  provider      = docker
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]
}

resource "docker_image" "logger" {
  provider      = docker
  name          = data.docker_registry_image.logger.name
  pull_triggers = [data.docker_registry_image.logger.sha256_digest]
}

