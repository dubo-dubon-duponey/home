output "bridge" {
  value = docker_network.dubo-bridge.name
}

output "vlan" {
  value = docker_network.dubo-vlan.name
}
