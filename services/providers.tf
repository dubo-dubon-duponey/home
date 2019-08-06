provider "docker" {
  version = "~> 2.0"
  host = "ssh://${local.nuc_fact_user}@${local.nuc_ip}:${local.nuc_fact_port}"
  alias = "nucomedon"
}

provider "docker" {
  version = "~> 2.0"
  host = "ssh://${local.dac_fact_user}@${local.dac_ip}:${local.dac_fact_port}"
  alias = "dacodac"
}

provider "docker" {
  version = "~> 2.0"
  host = "ssh://${local.nig_fact_user}@${local.nig_ip}:${local.nig_fact_port}"
  alias = "nightingale"
}

provider "random" {
  version = "~> 2.1"
}
