terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = ">= 2.9, < 2.10"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0, < 3.1"
    }
  }
  required_version = ">= 1.0, < 1.1"
}
