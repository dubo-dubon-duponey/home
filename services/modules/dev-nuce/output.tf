output "registry" {
  value = "http://${module.registry.name}:5000"
}

output "go" {
  value = "http://${module.go.name}:3000"
}

output "apt" {
  value = "http://${module.apt.name}:3142"
}
