provider "gandi" {
  key         = var.token
  # Only necessary if not the domain owner (eg: tech contact only for eg)
  # sharing_id = "<the sharing_id>"
}
