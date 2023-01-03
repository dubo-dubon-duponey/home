terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 2.23, < 2.24"
    }
  }
  required_version = ">= 1.0, < 1.4"
}
