FROM php:7.3-apache


# GRPC
RUN apt-get update -y \
	&& apt-get install -y  zlib1g-dev \
	&& pecl install grpc \
	&& docker-php-ext-enable grpc


RUN apt-get update -y && \
	apt-get install -y \
	curl \
	git \
	g++ \
	libicu-dev \
	libzip-dev \
	mariadb-client \
	cron \
	&& curl -sL https://deb.nodesource.com/setup_15.x | bash - \
	&& apt-get install -y nodejs \
	&& apt-get install -y  libmagickwand-dev --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php
RUN cd /usr/local/bin && mv composer.phar composer

RUN docker-php-source extract \
	&& pecl install imagick \
	&& printf "\n" | pecl install memcache-4.0.5.2 \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl bcmath zip sockets gd  mysqli pdo pdo_mysql  \
    && docker-php-ext-enable opcache intl bcmath zip sockets gd pdo pdo_mysql mysqli memcache imagick


RUN php -r "echo extension_loaded('grpc') ? 'yes' : 'no';"

ADD apache2.conf /etc/apache2/apache2.conf
RUN a2enmod rewrite
