output "ip" {
  value = docker_container.container.ip_address
}

output "name" {
  value = docker_container.container.name
}