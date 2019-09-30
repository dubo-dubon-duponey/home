output "root_password" {
  sensitive   = false
  value       = random_string.root_password.result
}

output "static_ip" {
  sensitive   = false
  value       = digitalocean_floating_ip.bastion.ip_address
}
