# Use an official PHP 8.2 image as the base image
FROM php:8.2-cli

# Install required system dependencies
RUN apt-get update \
    && apt-get install -y zlib1g-dev libpng-dev libzip-dev zip unzip git \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql calendar gd zip

# Install Composer 2.6.5 globally
COPY --from=composer:2.6.5 /usr/bin/composer /usr/bin/composer

# Install Symfony CLI globally
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Set the working directory in the container
WORKDIR /var/www/html

# Expose port 8000 for Symfony development server
EXPOSE 8000

# Copy the Symfony application files into the container
COPY . .

# Install dependencies
RUN composer install

# Start Symfony development server
CMD ["symfony", "server:start", "--port=8000", "--allow-http"]
