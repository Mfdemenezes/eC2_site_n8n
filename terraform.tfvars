# ===============================================
# Terraform Variables Values
# ===============================================

aws_region         = "us-east-1"
environment        = "production"
project_name       = "n8n-nginx-app"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
instance_type      = "t2.micro"
key_name           = ""  # Deixe vazio para usar SSM Session Manager
ssh_cidr           = "0.0.0.0/0"
s3_bucket_name     = "mfdemenezes-terraform-bucket"
