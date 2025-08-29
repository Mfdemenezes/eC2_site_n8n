#!/bin/bash

# Script super simples para atualizar apenas o index.html
# Uso: ./quick-update.sh

echo "⚡ Atualização rápida do index.html..."

# Upload para S3
aws s3 cp website/nginx/html/index.html s3://mfdemenezes-terraform-bucket/website/nginx/html/index.html

echo "✅ Index.html atualizado no S3!"
echo "💡 Agora execute na EC2:"
echo "cd /home/ec2-user/app && aws s3 cp s3://mfdemenezes-terraform-bucket/website/nginx/html/index.html nginx/html/index.html"
