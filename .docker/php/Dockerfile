FROM drupal:11.2.5-php8.4-fpm
ARG APP_USER_ID
ARG APP_GROUP_ID

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    wget \
    curl \
    nano

# Install uuidgen
RUN apt-get install -y uuid-runtime

# Install MYSQL CLIENT
RUN apt-get update && apt-get install -y default-mysql-client

# Set PROJECT USER
RUN groupadd -g ${APP_GROUP_ID} project \
    && useradd -l -u ${APP_USER_ID} -g project -m -s /bin/bash project
USER project
WORKDIR /project

COPY conf/php-fpm.conf /etc/php-fpm.conf
COPY conf/php.ini /usr/local/etc/php/conf.d/100-php.ini

# Set bash alias
RUN echo "alias la='ls -la --color=auto'" >> ~/.bashrc \
  && . ~/.bashrc
