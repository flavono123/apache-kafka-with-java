output "instance_key_private_key_pem" {
  value       = module.instance_key.private_key_openssh
  sensitive   = true
  description = "The private key in PEM format"
}

output "instance_public_ips" {
  value       = [for instance in module.instance : instance.public_ip]
  description = "The public IP address assigned to the instance"
}

output "ssh_command" {
  value = [
    for instance in module.instance :
    <<EOT
      Use this command to attach created instance:
      `ssh -i ${var.name_prefix}.pem ec2-user@${instance.public_ip}`
    EOT
  ]

  description = "The SSH command to connect to the instance"
}
