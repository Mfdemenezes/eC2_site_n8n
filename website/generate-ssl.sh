#!/bin/bash

# Script para gerar certificados SSL self-signed
echo "🔐 Gerando certificados SSL..."

# Criar diretórios se não existirem
mkdir -p /etc/ssl/certs
mkdir -p /etc/ssl/private

# Gerar chave privada
openssl genrsa -out /etc/ssl/private/nginx-selfsigned.key 2048

# Gerar certificado self-signed (válido por 365 dias)
openssl req -new -x509 -key /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt -days 365 \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=MeuSite/CN=98.87.200.120"

# Gerar Diffie-Hellman parameters
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# Ajustar permissões
chmod 600 /etc/ssl/private/nginx-selfsigned.key
chmod 644 /etc/ssl/certs/nginx-selfsigned.crt
chmod 644 /etc/ssl/certs/dhparam.pem

echo "✅ Certificados SSL criados com sucesso!"
