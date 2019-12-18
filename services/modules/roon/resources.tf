data "docker_registry_image" "image" {
  name = local.image_reference
}

resource "docker_image" "image" {
  provider      = docker
  name          = data.docker_registry_image.image.name
  pull_triggers = [data.docker_registry_image.image.sha256_digest]
}

/*
resource "docker_volume" "roon-data" {
  provider      = docker
  name          = "data-roon"
}
*/

resource "docker_volume" "tmp" {
  provider      = docker
  name          = "tmp-${local.container_name}"
}
