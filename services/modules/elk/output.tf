output "kibana" {
  value = "${docker_container.kibana.ip_address}:5601"
}

output "elastic" {
  value = "${docker_container.elastic.ip_address}:9200"
}
