output "instance_public_DNS" {
  description = "Public DNS address of the EC2 instance"
  value       = aws_instance.app_server[*].public_dns
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server[*].public_ip
}