FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --chown=nginx:nginx . /usr/share/nginx/html

# Garantir leitura pública para todos os PDFs do site
RUN find /usr/share/nginx/html -name "*.pdf" -exec chmod 644 {} \;

EXPOSE 80
