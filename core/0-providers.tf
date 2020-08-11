provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.nuc.user}@${local.nuc.ip}"
  alias = "nucomedon"
}
