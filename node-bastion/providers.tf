provider "docker" {
  version     = "~> 2.2"
  # XXX this is problematic - the new DNS record (TLL 300) may not be ready yet if this is a new instance and the record was updated
  # One idea: create a new random IN A record everytime, and pass that along to bust the cache
  # Conclusion: does not work, because the provider will race out the dns update mechanism (and there is no depend_on for providers)
  # For the same reason, it seems that using a connection in the resource does not work either
  # Updated: now using a pre-existing floating (static) ip pre-created in DO
  host        = "ssh://docker@${var.static_ip}:22"
}
