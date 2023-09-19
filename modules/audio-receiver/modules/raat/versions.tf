terraform {
  required_providers {
    // Note: this one needs to be recompiled to get NETCGO / mDNS working
    // How to is: ~/Projects/Go/src/github.com/kreuzwerker/terraform-provider-docker/do.sh
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 3.0, < 4.0"
    }
  }
  required_version = ">= 1.0, < 2.0"
}
