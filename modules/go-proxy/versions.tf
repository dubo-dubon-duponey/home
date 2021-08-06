terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 2.14, < 2.15"
    }
  }
  required_version = ">= 1.0, < 1.1"
}
