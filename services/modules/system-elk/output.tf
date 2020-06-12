output "elastic_ip" {
  value = "${module.elastic.ip}:${module.elastic.port}"
}

output "elastic_name" {
  value = module.elastic.name
}

output "kibana_ip" {
  value = "${module.kibana.ip}:${module.kibana.port}"
}

output "kibana_name" {
  value = module.kibana.name
}
