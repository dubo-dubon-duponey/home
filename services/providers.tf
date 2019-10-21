provider "docker" {
  # version = "~> 2.6"
  host = "ssh://${local.nuc_fact_user}@${local.nuc_ip}"
  alias = "nucomedon"
}

provider "docker" {
  # version = "~> 2.6"
  host = "ssh://${local.dac_fact_user}@${local.dac_ip}"
  alias = "dacodac"
}

provider "docker" {
  # version = "~> 2.6"
  host = "ssh://${local.nig_fact_user}@${local.nig_ip}"
  alias = "nightingale"
}

provider "random" {
  version = "~> 2.2"
}
