output "instance_key_private_key_pem" {
  value       = module.instance_key.private_key_openssh
  sensitive   = true
  description = "The private key in PEM format"
}

output "instance_public_ip" {
  value       = module.instance.public_ip
  description = "The public IP address assigned to the instance"
}

output "ssh_command" {
  value       = <<EOT
    Use this command to attach created instance:
    `ssh -i ${local.name}.pem ec2-user@${module.instance.public_ip}`
  EOT
  description = "The SSH command to connect to the instance"
}
