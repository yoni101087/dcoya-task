# Use Alpine Linux as the base image
FROM alpine:latest

# Install Nginx and Prometheus Nginx Exporter
RUN apk update && apk add nginx nginx-mod-http-headers-more && \
    mkdir -p /run/nginx && \
    chown -R nginx:nginx /var/lib/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /run/nginx && \
    apk add --no-cache --virtual .build-deps curl && \
    curl -Lo /tmp/nginx-prometheus-exporter.tar.gz https://github.com/nginxinc/nginx-prometheus-exporter/releases/latest/download/nginx-prometheus-exporter-linux-amd64.tar.gz && \
    tar -zxvf /tmp/nginx-prometheus-exporter.tar.gz -C /tmp/ && \
    mv /tmp/nginx-prometheus-exporter /usr/local/bin/ && \
    rm -f /tmp/nginx-prometheus-exporter.tar.gz && \
    apk del .build-deps

# Create a directory for the index.html file
RUN mkdir -p /var/www/html

# Copy the index.html file to the container
COPY index.html /var/www/html/

# Copy the environment file containing the machine name
COPY machine_name.txt /var/www/html/

# Configure Nginx to use our custom configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Tell Docker to run Nginx as the non-root user
USER nginx

# Expose ports 80 (HTTP) and 9113 (Prometheus metrics)
EXPOSE 80
EXPOSE 9113

# Start Nginx with the Prometheus exporter
CMD ["nginx", "-g", "daemon off;", "&", "nginx-prometheus-exporter"]
