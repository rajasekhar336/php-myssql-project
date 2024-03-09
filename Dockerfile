# Use a lightweight base image
FROM php:7.4-apache

# Set environment variables
#ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Update package lists
RUN apt-get update && \
    apt-get install -y \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        unzip \
        && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo pdo_mysql zip

# Enable Apache modules
RUN a2enmod rewrite headers

# Set recommended PHP.ini settings
RUN { \
        echo 'file_uploads = On'; \
        echo 'memory_limit = 256M'; \
        echo 'upload_max_filesize = 64M'; \
        echo 'post_max_size = 64M'; \
        echo 'max_execution_time = 600'; \
        echo 'date.timezone = UTC'; \
    } > /usr/local/etc/php/php.ini

# Copy Apache configuration files
COPY apache2/apache2.conf /etc/apache2/apache2.conf
COPY apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy project files
WORKDIR /var/www/html
COPY app/ .

# Install Composer (dependency manager for PHP)
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install project dependencies
#RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Set the entry point
CMD ["apache2-foreground"]

