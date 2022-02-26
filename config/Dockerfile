ARG BASE_BUILD_IMAGE
FROM $BASE_BUILD_IMAGE

ENV TZ=Europe/Moscow

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
    apt-get clean && apt-get update && apt-get install -y \
    iproute2 \
    msmtp

#LARAVEL LIB
# RUN apt-get update \
#     && apt-get install -y libgd-dev php-gd\
#     && apt-get install -y libzip-dev php-zip \
#     && apt-get install -y zip unzip \
#     && apt-get install -y php-mbstring php-memcache

# Install composer
RUN apt-get update \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

    #NPM
RUN apt-get install -y nodejs npm

# laravel installer and packages
RUN composer global require laravel/installer \
    && composer require laravel/ui \
    && composer install

WORKDIR /var/www/html

# Change default DocumentRoot in apache config
COPY config/php-conf.d/apache.conf /etc/apache2/sites-available/000-default.conf
COPY config/php-conf.d/local.ini /usr/local/etc/php/conf.d/local.ini
COPY config/msmtp/msmtprc /etc/msmtprc