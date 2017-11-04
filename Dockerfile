FROM alpine:3.6

# Linux
RUN apk update

# Nginx
RUN apk add nginx
RUN adduser -D -u 1000 -g 'www' www
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

# PHP
RUN apk add php7 php7-fpm
RUN apk add php7-gd php7-mysqli php7-zlib php7-curl php7-json php7-mcrypt php7-phar php7-iconv php7-pdo php7-pdo_mysql

# PHP Settings
ENV TIMEZONE UTC
ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M

# Set environments
RUN sed -i "s|;*daemonize\s*=\s*yes|daemonize = no|g" /etc/php7/php-fpm.conf
RUN sed -i "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm7.sock|g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s|;*listen.owner = nobody|listen.owner = www|g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s|;*listen.group = nobody|listen.group = www|g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s|;*listen.mode = 0660|listen.mode = 0660|g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini
RUN sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
RUN sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|i" /etc/php7/php.ini
RUN sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
RUN sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
RUN sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo=0|i" /etc/php7/php.ini

# Composer
RUN apk add curl
RUN curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/local/bin --filename=composer

# Supervisor
RUN apk add supervisor