FROM php:8.1-apache

# Install necessary libraries, PHP extensions etc.
RUN apt-get update && apt-get install -y \
    libpq-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libxml2-dev \
    postgresql-client unzip rsync gettext-base wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd opcache xml \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

# Enable OPcache and configure recommended settings
RUN echo "zend_extension=opcache.so" > /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.max_accelerated_files=4000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.revalidate_freq=60" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
    && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Copy and extract project files
RUN wget -O /var/www/html/dipas.zip https://bitbucket.org/geowerkstatt-hamburg/dipas/downloads/dipas-os-4.0.11.zip \
    && unzip /var/www/html/dipas.zip -d /var/www/html/dipas/ \
    && rm -rf /var/www/html/dipas.zip

# Copy configuration files
COPY ./config/drupal/settings.php /var/www/html/dipas/htdocs/drupal/sites/default/settings.php
COPY ./config/drupal/drupal.services.yml /var/www/html/dipas/config/drupal.services.yml
COPY ./config/drupal/drupal.reverse-proxy-settings.php /var/www/html/dipas/config/drupal.reverse-proxy-settings.php

# Copy and set entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Configure Apache and PHP
COPY ./config/apache/yourdomain.de.conf /etc/apache2/sites-available/
RUN a2enmod rewrite \
    && a2dissite 000-default.conf \
    && a2ensite yourdomain.de.conf \
    && echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Set entrypoint and default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
