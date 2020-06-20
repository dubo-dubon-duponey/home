provider "docker" {
  version = "= 2.6"
  alias = "macarena"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.dac.user}@${local.dac.ip}"
  alias = "dacodac"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.nuc.user}@${local.nuc.ip}"
  alias = "nucomedon"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.cor.user}@${local.cor.ip}"
  alias = "corpisone"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.6"
  host = "ssh://${local.nig.user}@${local.nig.ip}"
  alias = "nightingale"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
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
