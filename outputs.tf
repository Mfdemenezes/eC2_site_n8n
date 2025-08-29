# ===============================================
# Terraform Outputs
# ===============================================

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.web.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web.id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "website_url" {
  description = "Website URL (HTTPS)"
  value       = "https://${aws_eip.web.public_ip}"
}

output "n8n_url" {
  description = "N8N URL (via HTTPS/Nginx proxy)"
  value       = "https://${aws_eip.web.public_ip}/n8n/"
}

output "n8n_direct_url" {
  description = "N8N Direct URL (HTTP - para debug)"
  value       = "http://${aws_eip.web.public_ip}:5678"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = var.key_name != "" ? "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_eip.web.public_ip}" : "Use AWS Systems Manager Session Manager"
}
