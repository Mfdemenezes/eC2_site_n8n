FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache curl
USER node

ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=adminpass123
ENV N8N_PORT=5678
ENV DB_TYPE=sqlite

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s CMD curl -f http://localhost:5678/healthz || exit 1

EXPOSE 5678

CMD ["n8n"]
