#!/bin/bash

# Atualizar sistema
yum update -y

# Instalar Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Instalar AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Criar diretório da aplicação
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Baixar docker-compose.yml do S3 (será criado depois)
aws s3 cp s3://mfdemenezes-terraform-bucket/docker-compose.yml . || echo "Docker compose não encontrado no S3"

# Criar diretórios para volumes
mkdir -p ./nginx/html
mkdir -p ./n8n-data

# Baixar arquivos do website do S3
aws s3 sync s3://mfdemenezes-terraform-bucket/website/ ./nginx/html/ || echo "Website files não encontrados"

# Tornar script SSL executável
chmod +x ./generate-ssl.sh 2>/dev/null || echo "SSL script not found"

# Definir permissões
chown -R ec2-user:ec2-user /home/ec2-user/app

# Corrigir permissões do Docker - reiniciar serviço após adicionar usuário ao grupo
systemctl restart docker
sleep 5

# Iniciar containers com permissões adequadas (executar como ec2-user)
if [ -f docker-compose.yml ]; then
    # Executar docker-compose como ec2-user com permissões de grupo adequadas
    sudo -u ec2-user sg docker -c "docker-compose up -d"
fi

# Registrar conclusão da configuração
echo "$(date): Configuração do Docker concluída" >> /var/log/cloud-init-output.log
