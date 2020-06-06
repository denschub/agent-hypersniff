FROM php:apache
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY . /var/www/html/
WORKDIR /var/www/html/
EXPOSE 8000
RUN apt-get update && apt-get install -y unzip && \
    sed -ri -e 's/ 80/ 8000/g' /etc/apache2/ports.conf && \
    sed -ri -e 's/\*:80/*:8000/g' /etc/apache2/sites-available/000-default.conf && \
    a2enmod rewrite && \
    composer install
