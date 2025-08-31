#!/bin/bash

# Logs para debug
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "🚀 Iniciando configuração da instância ${project_name}..."

#Instalar Docker e Git
sudo yum update -y
sudo yum install git -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker ssm-user
id ec2-user ssm-user
sudo newgrp docker

#Ativar docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

#Instalar docker compose 2
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

#Adicionar swap
sudo dd if=/dev/zero of=/swapfile bs=128M count=32
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

#Instalar node e npm
curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash -
sudo yum install -y nodejs

# Instalar AWS CLI para baixar arquivos do S3
sudo yum install -y awscli

# Criar diretório para aplicação
sudo mkdir -p /opt/app
cd /opt/app

echo "📥 Baixando configurações dos containers do S3..."

# Baixar diretórios do S3 (se bucket configurado)
if [ -n "${s3_bucket_name}" ]; then
    echo "Baixando do bucket: ${s3_bucket_name}"
    
    # Baixar diretório n8n
    sudo aws s3 cp s3://${s3_bucket_name}/n8n/ /opt/app/n8n/ --recursive --quiet || echo "Diretório n8n não encontrado no S3"
    
    # Baixar diretório website  
    sudo aws s3 cp s3://${s3_bucket_name}/website/ /opt/app/website/ --recursive --quiet || echo "Diretório website não encontrado no S3"
    
else
    echo "⚠️  Bucket S3 não configurado, criando configurações padrão..."
fi

# Criar estrutura de diretórios se não existir
sudo mkdir -p {n8n,website}

# Configuração padrão do N8N se não existir
if [ ! -f "/opt/app/n8n/Dockerfile" ]; then
    echo "📦 Criando Dockerfile padrão do N8N..."
    sudo tee /opt/app/n8n/Dockerfile > /dev/null << 'EOF'
FROM n8nio/n8n:latest
USER root
RUN apk add --no-cache curl
USER node
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=adminpass123
ENV N8N_PATH=/n8n
ENV N8N_PORT=5678
ENV DB_TYPE=sqlite
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s CMD curl -f http://localhost:5678/healthz || exit 1
EXPOSE 5678
CMD ["n8n"]
EOF
fi

# Configuração padrão do Website se não existir
if [ ! -f "/opt/app/website/Dockerfile" ]; then
    echo "🌐 Criando Dockerfile padrão do Website..."
    sudo tee /opt/app/website/Dockerfile > /dev/null << 'EOF'
FROM nginx:alpine
COPY . /usr/share/nginx/html
RUN find /usr/share/nginx/html -type f -exec chmod 644 {} \;
EXPOSE 8080
RUN sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf
EOF
fi

# Se não existem arquivos do website, criar um index.html básico
if [ ! -f "/opt/app/website/index.html" ]; then
    echo "📄 Criando index.html básico (website não encontrado no S3)..."
    sudo tee /opt/app/website/index.html > /dev/null << EOF
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>${project_name} - Website</title>
<style>body{font-family:Arial,sans-serif;margin:0;padding:20px;background:linear-gradient(135deg,#667eea,#764ba2);color:white;min-height:100vh;text-align:center}.container{max-width:800px;margin:0 auto}h1{font-size:3em;margin-bottom:20px}</style></head>
<body><div class="container"><h1>🌐 ${project_name}</h1><p>Website rodando na porta 8080</p>
<p>🔗 <a href="http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):5678" style="color:white">Acessar N8N (Porta 5678)</a></p></div></body></html>
EOF
else
    echo "✅ Website encontrado - usando arquivos do S3"
fi



# Criar docker-compose.yml
echo "🐳 Criando docker-compose.yml..."
sudo tee /opt/app/docker-compose.yml > /dev/null << EOF
version: '3.8'

services:
  website:
    build: ./website
    container_name: ${project_name}-website
    restart: unless-stopped
    ports:
      - "8080:8080"
    networks:
      - app-network

  n8n:
    build: ./n8n
    container_name: ${project_name}-n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    volumes:
      - n8n_data:/home/node/.n8n
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=adminpass123
    networks:
      - app-network

volumes:
  n8n_data:
    driver: local

networks:
  app-network:
    driver: bridge
EOF

# Ajustar permissões
sudo chown -R ec2-user:ec2-user /opt/app
sudo chmod -R 755 /opt/app

# Build e execução dos containers
echo "🔨 Fazendo build dos containers..."
cd /opt/app

# Build das imagens
sudo docker compose build

echo "🚀 Iniciando containers..."
# Subir os containers
sudo docker compose up -d

# Verificar status dos containers
echo "📊 Verificando status dos containers..."
sudo docker compose ps

# Configurar limpeza automática
echo "🧹 Configurando limpeza automática..."
echo "0 2 * * * docker system prune -f" | sudo crontab -

echo "🎉 Configuração concluída!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Website: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
echo "⚡ N8N: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):5678"
echo "🔐 N8N Login: admin / adminpass123"
echo "🎯 Elastic IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "📦 S3 Bucket: ${s3_bucket_name}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"