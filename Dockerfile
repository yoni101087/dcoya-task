# Use Alpine Linux as the base image
FROM alpine:latest

# Install Nginx
RUN apk update && apk add nginx

# Create a directory for the index.html file
RUN mkdir -p /var/www/html

# Copy the index.html file to the container
COPY index.html /var/www/html/

# Copy the environment file containing the machine name
COPY machine_name.txt /var/www/html 

# Configure Nginx to use our custom configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
