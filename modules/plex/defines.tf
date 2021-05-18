####################################################################
# This is internal and purely local variables derived from input variables and defaults
# Generic to all our containers
####################################################################

// Locals derived from input and defaults
locals {
  # Image to use
  image_reference         = length(var.image) != 0 ? "${var.registry}/${var.image}" : "${var.registry}/${local.defaults.image}"

  # Container settings
  container_name          = length(var.nickname) != 0 ? var.nickname : local.defaults.nickname
  container_hostname      = "${local.container_name}.${var.hostname}"
  container_user          = var.user
  container_dns           = var.dns
  container_networks      = var.networks
  container_privileged    = local.defaults.privileged
  container_read_only     = local.defaults.read_only
  container_restart       = local.defaults.restart
  container_expose_type   = local.defaults.expose_type

  # Container properties
  container_devices       = local.defaults.devices
  container_group_add     = local.defaults.group_add
  container_command       = length(var.command) != 0 ? var.command : local.defaults.command

  container_capabilities  = var.user == "root" ? local.defaults.caps_if_root : []

  # Labels
  log                     = var.log
  labels                  = local.defaults.labels
}
