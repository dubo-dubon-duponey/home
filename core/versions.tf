terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 2.9, < 2.10"
    }
  }
  required_version = ">= 0.14, < 0.15"
}
