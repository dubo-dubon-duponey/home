terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 2.15, < 2.16"
    }
  }
  required_version = ">= 1.0, < 1.2"
}
