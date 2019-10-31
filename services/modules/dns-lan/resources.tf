data "docker_registry_image" "dns" {
  name = local.image
}

resource "docker_image" "dns" {
  provider      = docker
  name          = data.docker_registry_image.dns.name
  pull_triggers = [data.docker_registry_image.dns.sha256_digest]
}
