FROM ubuntu:18.04

RUN ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN apt-get update && apt-get install -y git vim mariadb-server mariadb-client curl software-properties-common

RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update && apt-get install -y php7.4 php7.4-mbstring php7.4-curl php7.4-dom php7.4-imap php7.4-mysql php7.4-gd
RUN apt-get update && apt-get install -y zip unzip php-zip

RUN mkdir /opt/agorakit && chown -R www-data:www-data /opt/agorakit /var/www

#ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
USER www-data
RUN git clone https://github.com/agorakit/agorakit /opt/agorakit
WORKDIR /opt/agorakit
RUN curl --silent --show-error https://getcomposer.org/installer | php && php composer.phar install

USER root
RUN rm -rf /var/www/html && ln -s /opt/agorakit/public/ /var/www/html
ADD agorakit/000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD agorakit/default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf
ADD agorakit/apache2.conf /etc/apache2/apache2.conf
RUN a2enmod ssl headers rewrite
RUN echo 'upload_max_filesize = 100M' >> /etc/php/7.4/apache2/php.ini 
COPY agorakit/entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
CMD /entrypoint.sh

RUN apt-get update && apt-get install -y python3-pip && pip3 install awscli awscli-plugin-endpoint
COPY agorakit/megacmd-xUbuntu_18.04_amd64.deb /tmp/megacmd-xUbuntu_18.04_amd64.deb
RUN apt-get install libcrypto++6 libc-ares2 libmediainfo0v5 libpcrecpp0v5 libzen0v5 libmms0 libtinyxml2-6 libpcre3 /tmp/megacmd-xUbuntu_18.04_amd64.deb
COPY agorakit/backup.sh /backup.sh
RUN chmod a+x /backup.sh

EXPOSE 443
EXPOSE 80
#RUN sed -i "0,/update/{s/@can('update/@can('delete/}" /opt/agorakit/resources/views/comments/comment.blade.php
