resource "docker_image" "roon" {
  provider      = docker
  name          = data.docker_registry_image.roon.name
  pull_triggers = [data.docker_registry_image.roon.sha256_digest]
}

/*
resource "docker_volume" "roon" {
  provider      = docker
  name          = "roon"
}
*/
