provider "docker" {
  host = "ssh://${local.providers.nuc.user}@${local.providers.nuc.host}"
  alias = "nuc"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  host = "ssh://${local.providers.nig.user}@${local.providers.nig.host}"
  alias = "nig"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  host = "ssh://${local.providers.dac.user}@${local.providers.dac.host}"
  alias = "dac"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  alias = "mac"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

// XXXtmp dead
/*
provider "docker" {
host = "ssh://${local.providers.cor.user}@${local.providers.cor.host}"
  alias = "cor"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}
*/

resource "random_string" "afp_pwd" {
  length  = 30
  # XXX the way we change password in the docker image does not bode well with special chars apparently
  special = false
  number  = true
  upper   = true
  lower   = true
}
