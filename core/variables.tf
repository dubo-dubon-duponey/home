variable "dns_upstream_name" {
  description = "Upstream DNS server name"
  type        = string
  default     = "dns.example.com"
}

variable "dns_upstream_ips" {
  description = "Upstream TLS DNS server urls"
  type        = list(string)
  default     = [
    "1.2.3.4",
    "5.6.7.8",
  ]
}

# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
  dns_upstream_name = var.dns_upstream_name
  dns_upstream_ips  = var.dns_upstream_ips

  dac_fact_user     = "pi"
  dac_ip            = "192.168.1.7"
  dac_hostname      = "dacodac.container"

  nuc_fact_user     = "dmp"
  nuc_ip            = "192.168.1.8"
  nuc_hostname      = "nucomedon.container"

  nig_fact_user     = "pi"
  nig_ip            = "192.168.1.9"
  nig_hostname      = "nightingale.container"

  mac_hostname      = "macarella.container"
}
