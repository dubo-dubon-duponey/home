
/*
variable "subnetv6" {
  description = "Subnet for ip/mac vlan"
  type        = string
  default     = "2001:3200:3200::/64"
}

variable "gatewayv6" {
  description = "Network gateway for ip/mac vlan"
  type        = string
  default     = "2001:3200:3200::1"
}
*/

/*
variable "rangev6" {
  description = "Range for ip/mac vlan"
  type        = string
  default     = "2001:3200:3200::10/60"
}
*/

//  ipv6        = true

/*
ipam_config {
  subnet    = var.subnetv6
  gateway   = var.gatewayv6
//    ip_range  = var.rangev6
}
*/

/*
subnet    = "2002:c0a8:100::/124"
gateway   = "2002:c0a8:101::"
range     = "2002:c0a8:150::/60"

subnet    = "2001:3200:3200::/64"
gateway   = "2001:3200:3200::1"
range     = "2001:3200:3200::10/60"
*/
# From Docker documentation
# 2001:db8:1::/64

