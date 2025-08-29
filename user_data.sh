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

# Make SSL script executable
chmod +x ./generate-ssl.sh 2>/dev/null || echo "SSL script not found"

# Set permissions
chown -R ec2-user:ec2-user /home/ec2-user/app

# Fix Docker permissions - restart Docker service after adding user to group
systemctl restart docker
sleep 5

# Start containers with proper permissions (run as ec2-user)
if [ -f docker-compose.yml ]; then
    # Run docker-compose as ec2-user with proper group permissions
    sudo -u ec2-user sg docker -c "docker-compose up -d"
fi

# Log the setup completion
echo "$(date): Docker setup completed" >> /var/log/cloud-init-output.log
