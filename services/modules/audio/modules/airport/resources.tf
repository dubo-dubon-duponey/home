data "docker_registry_image" "image" {
  name = local.image_reference
}

# Images
resource "docker_image" "image" {
  provider      = docker
  name          = data.docker_registry_image.image.name
  pull_triggers = [data.docker_registry_image.image.sha256_digest]
}
