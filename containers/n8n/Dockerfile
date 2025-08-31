FROM n8nio/n8n:latest

# Configurar ambiente
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=admin123
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV DB_TYPE=sqlite
ENV N8N_SECURE_COOKIE=false

# Volume para dados
VOLUME ["/home/node/.n8n"]

# Porta de exposição
EXPOSE 5678

# Healthcheck simplificado
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || exit 1

# Comando de inicialização - deixa o n8n fazer o que sabe
CMD ["n8n"]
