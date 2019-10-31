output "ip_kibana" {
  value = docker_container.kibana.ip_address
}

output "ip_elastic" {
  value = docker_container.elastic.ip_address
}
