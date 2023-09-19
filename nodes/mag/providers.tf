provider "docker" {
  host = "ssh://${local.providers.user}@${local.providers.host}"
  alias = "node"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}
