data "docker_registry_image" "logger" {
  name = local.image_logger
}

data "docker_registry_image" "dns" {
  name = local.image_dns
}

