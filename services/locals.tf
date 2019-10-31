# XXX https://github.com/hashicorp/terraform/issues/3536#issuecomment-386054967
# Terraform doesn't use CGO, hence fail to pick-up the native resolver, hence doesn't resolve local resources...
# This is fundamentally: https://github.com/golang/go/issues/12524
# default = "raspberry.local"

locals {
  gateway         = "192.168.1.1"
  subnet          = "192.168.1.0/24"

  dac_fact_iface  = "eth0"
  dac_range       = "192.168.1.16/28"
  dac_fact_user   = "pi"
  dac_ip          = "192.168.1.7"

  nuc_fact_iface  = "eno1"
  nuc_range       = "192.168.1.48/28"
  nuc_fact_user   = "dmp"
  nuc_ip          = "192.168.1.8"

  nig_fact_iface  = "wlan0"
  nig_range       = "192.168.1.80/28"
  nig_fact_user   = "pi"
  nig_ip          = "192.168.1.9"
}
