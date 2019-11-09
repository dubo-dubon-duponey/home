provider "gandi" {
  key         = var.token
  # Only necessary if not the domain owner (eg: tech contact only for eg)
  # sharing_id  = "mangleddeutz"
  # XXX this is foobared on gandi side, and will not grant the appropriate privileges to create new zones...
  # sharing_id = "<the sharing_id>"
}
