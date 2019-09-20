output "bastion_root_password" {
  sensitive   = false
  value       = random_string.root_password.result
}
