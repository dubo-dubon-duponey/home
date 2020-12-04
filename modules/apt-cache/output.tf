output "network" {
  value = docker_container.container.network_data
}

output "name" {
  value = docker_container.container.name
}

output "port" {
  value = var.port
}
