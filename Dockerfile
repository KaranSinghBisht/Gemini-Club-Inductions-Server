# Use the official Ubuntu as base image
FROM ubuntu:latest

# Set the working directory
WORKDIR /app

# Copy SQL script to initialize the database
COPY init.sql /docker-entrypoint-initdb.d/

# Copy the necessary files
COPY sysad-task1-mentees_domain.txt /app/sysad-task1-mentees_domain.txt

# Update and install required packages
RUN apt-get update && \
    apt-get install -y sudo apache2 php libapache2-mod-php php-mysql acl && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get install -y nodejs mysql-client && \
    chown -R www-data:www-data /app && \
    chmod -R 755 /app && \
    chmod 644 /app/sysad-task1-mentees_domain.txt

# Copy apache config file
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy and set permissions for all scripts
COPY *.sh /app/

# Copy the node application files
COPY gemini-inductions /app/gemini-inductions

RUN chmod +x /app/*.sh

# Expose port 8080
EXPOSE 8080
EXPOSE 5000

# Start services
CMD service apache2 start && tail -f /dev/null
