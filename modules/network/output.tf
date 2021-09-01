/*
output "bridge" {
  value = docker_network.dubo-bridge.id
}
*/

output "vlan" {
  value = docker_network.dubo-vlan.id
}
