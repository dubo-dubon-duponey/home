# Registry image
data "docker_registry_image" "image" {
  name = local.image_reference
}

# Image
resource "docker_image" "image" {
  provider      = docker
  name          = data.docker_registry_image.image.name
  pull_triggers = [data.docker_registry_image.image.sha256_digest]
}

# Container
resource "docker_container" "container" {
  provider      = docker
  image         = docker_image.image.latest

  name          = local.container_name
  hostname      = local.container_hostname
  dns           = local.container_dns
  user          = local.container_user

  restart       = "always"
  read_only     = false # XXX right now, we have to have this, because of user creation

  capabilities {
    drop  = ["ALL"]
    add   = local.capabilities
  }

  env       = local.env
  group_add = local.group_add
  command   = local.command

  dynamic "networks_advanced" {
    for_each = local.container_networks
    content {
      name = networks_advanced.key
      ipv4_address = networks_advanced.value
    }
  }

  dynamic "ports" {
    for_each = local.expose
    content {
      internal    = ports.value
      external    = ports.key
      protocol    = local.expose_type
    }
  }

  dynamic "devices" {
    for_each = toset(local.devices)
    content {
      host_path = devices.value
      container_path = devices.value
      permissions = "rwm"
    }
  }

  dynamic "volumes" {
    for_each = local.volumes
    content {
      volume_name     = volumes.value
      container_path  = volumes.key
    }
  }

  dynamic "mounts" {
    for_each = local.mounts
    content {
      target = mounts.key
      source = mounts.value
      read_only   = true
      type        = "bind"
    }
  }

  dynamic "mounts" {
    for_each = local.mountsrw
    content {
      target = mounts.key
      source = mounts.value
      read_only   = false
      type        = "bind"
    }
  }

  labels {
    label = "co.elastic.logs/enabled"
    value = local.log
  }

  dynamic "labels" {
    for_each = local.labels
    content {
      label = labels.key
      value = labels.value
    }
  }
# XXX is this really a necessity?
  provisioner "local-exec" {
    command = "echo 'Users have been configured for netatalk: ${local.users} (${local.passwords}). This will never be displayed ever again.'"
  }
}
