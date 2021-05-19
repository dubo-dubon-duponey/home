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

  restart       = local.container_restart
  read_only     = local.container_read_only

  privileged    = local.container_privileged

  capabilities {
    drop  = ["ALL"]
    add   = local.container_capabilities
  }

  env       = local.env
  group_add = local.container_group_add
  command   = local.container_command

  dynamic "networks_advanced" {
    for_each = local.container_networks
    content {
      name = networks_advanced.key
      ipv4_address = networks_advanced.value
    }
  }

  dynamic "host" {
    for_each = local.container_hosts
    # XXX this is sub-optimal - certain fancy services may expose multiple ports with different types
    content {
      host        = host.key
      ip          = host.value
    }
  }

  dynamic "ports" {
    for_each = local.container_expose
    # XXX this is sub-optimal - certain fancy services may expose multiple ports with different types
    content {
      internal    = ports.value
      external    = ports.key
      protocol    = local.container_expose_type
    }
  }

  dynamic "devices" {
    for_each = toset(local.container_devices)
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
}
