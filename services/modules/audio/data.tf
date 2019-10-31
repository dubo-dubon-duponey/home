data "docker_registry_image" "airport" {
  name = local.image_airport_server
}

data "docker_registry_image" "homekit-alsa" {
  name = local.image_volume_control
}

data "docker_registry_image" "raat" {
  name = local.image_raat_server
}
