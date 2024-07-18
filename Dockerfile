# Gunakan PHP versi 8.0
FROM php:8.1-fpm

# Install dependensi yang dibutuhkan oleh Laravel
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        libpng-dev \
        libonig-dev \
        libxml2-dev \
        zip \
        unzip \
        nginx \
        supervisor

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy aplikasi Laravel Anda
COPY . .

# Install dependencies Laravel menggunakan Composer
RUN composer install

# Buat environment file dari contoh environment
RUN cp .env.example .env

# Generate key Laravel
RUN php artisan key:generate

# Set permission dan konfigurasi nginx
COPY docker/nginx.conf /etc/nginx/nginx.conf
RUN chmod -R 755 storage bootstrap/cache
EXPOSE 80

# Jalankan perintah saat container dimulai
CMD ["php-fpm"]
