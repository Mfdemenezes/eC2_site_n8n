# Configurações básicas
region      = "us-east-1"
environment = "Dev"

# Configurações EC2
ec2_instance_type = "t2.micro"
ec2_count         = 1
ec2_name          = "my_instancia"


# Configurações de rede
vpc_cidr    = "10.0.0.0/16"
subnet_cidr = "10.0.1.0/24"


# Configurações EBS
ebs_volume_size = 10
ebs_volume_type = "gp3"


# Configurações S3
s3_bucket_name = "mfdemenezes-terraform-bucket"





