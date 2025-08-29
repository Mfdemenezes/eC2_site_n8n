#!/bin/bash

# Update system
yum update -y

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Create application directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Download docker-compose.yml from S3 (será criado depois)
aws s3 cp s3://mfdemenezes-terraform-bucket/docker-compose.yml . || echo "Docker compose não encontrado no S3"

# Create directories for volumes
mkdir -p ./nginx/html
mkdir -p ./n8n-data

# Download website files from S3
aws s3 sync s3://mfdemenezes-terraform-bucket/website/ ./nginx/html/ || echo "Website files não encontrados"

# Set permissions
chown -R ec2-user:ec2-user /home/ec2-user/app

# Start containers (if docker-compose.yml exists)
if [ -f docker-compose.yml ]; then
    docker-compose up -d
fi
