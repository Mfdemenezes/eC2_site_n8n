#!/bin/bash

# Script para atualizar apenas o website sem refazer todo o deploy
# Uso: ./update-website.sh

set -e

echo "🚀 Atualizando website..."

# 1. Upload do index.html para S3
echo "📤 Enviando index.html para o S3..."
aws s3 cp website/nginx/html/index.html s3://mfdemenezes-terraform-bucket/website/nginx/html/index.html

# 2. Obter IP da instância EC2
echo "🔍 Obtendo IP da instância EC2..."
INSTANCE_IP=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=*my-infra*" "Name=instance-state-name,Values=running" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)

if [ "$INSTANCE_IP" = "None" ] || [ -z "$INSTANCE_IP" ]; then
    echo "❌ Instância EC2 não encontrada ou não está executando"
    exit 1
fi

echo "📍 IP da EC2: $INSTANCE_IP"

# 3. Atualizar arquivo na EC2 via SSM
echo "🔄 Atualizando arquivo na EC2..."
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=*my-infra*" "Name=instance-state-name,Values=running" \
    --query "Reservations[0].Instances[0].InstanceId" \
    --output text)

aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name "AWS-RunShellScript" \
    --parameters 'commands=["cd /home/ec2-user/app && aws s3 cp s3://mfdemenezes-terraform-bucket/website/nginx/html/index.html nginx/html/index.html && echo \"Website atualizado com sucesso\""]' \
    --output text

echo "✅ Website atualizado com sucesso!"
echo "🌐 Verificar: http://$INSTANCE_IP"
echo "🌐 Verificar: http://$INSTANCE_IP:8080"
echo "🔐 Verificar: https://$INSTANCE_IP"
