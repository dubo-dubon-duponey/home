provider "docker" {
  version = "= 2.6"
  alias = "macarena"
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.dac.user}@${local.dac.ip}"
  alias = "dacodac"
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.nuc.user}@${local.nuc.ip}"
  alias = "nucomedon"
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.cor.user}@${local.cor.ip}"
  alias = "corpisone"
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.nig.user}@${local.nig.ip}"
  alias = "nightingale"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_string" "afp_pwd" {
  length  = 30
  # XXX the way we change password in the docker image does not bode well with special chars apparently
  special = false
  number  = true
  upper   = true
  lower   = true
}
