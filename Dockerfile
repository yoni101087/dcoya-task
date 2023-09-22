# Use Alpine Linux as the base image
FROM alpine:latest

# Install Nginx
RUN apk update && apk add nginx && \
    mkdir -p /run/nginx && \
    chown -R nginx:nginx /var/lib/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /run/nginx

# Create a directory for the index.html file
RUN mkdir -p /var/www/html

# Copy the index.html file to the container
COPY index.html /var/www/html/

# Copy the environment file containing the machine name
COPY machine_name.txt /var/www/html/

# Configure Nginx to use our custom configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create a non-root user and group for Nginx
RUN addgroup -S nginx && adduser -S -D -H -G nginx nginx

# Tell Docker to run Nginx as the non-root user
USER nginx

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
