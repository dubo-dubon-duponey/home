resource "random_string" "afp_pwd" {
  length  = 30
  # XXX the way we change password in the docker image does not bode well with special chars apparently
  special = false
  number  = true
  upper   = true
  lower   = true
}
