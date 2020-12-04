provider "docker" {
  version = "= 2.8.0"
  host = "ssh://${local.providers.nuc.user}@${local.providers.nuc.host}"
  alias = "nuc"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.8.0"
  host = "ssh://${local.providers.nig.user}@${local.providers.nig.host}"
  alias = "nig"

  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.8.0"
  host = "ssh://${local.providers.dac.user}@${local.providers.dac.host}"
  alias = "dac"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}

provider "docker" {
  version = "= 2.8.0"
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
  version = "= 2.8.0"
host = "ssh://${local.providers.cor.user}@${local.providers.cor.host}"
  alias = "cor"
  registry_auth {
    address = local.registry.address
    username = local.registry.username
    password = local.registry.password
  }
}
*/

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
