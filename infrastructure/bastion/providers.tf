# Configure the DigitalOcean Provider
provider "random" {
  version     = "~> 2.2"
}

provider "digitalocean" {
  version     = "~> 1.7"
  token       = var.token
}
