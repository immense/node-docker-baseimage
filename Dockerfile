FROM ubuntu:trusty
MAINTAINER Christian Bankester <cbankester@immense.net>

## Prepare
RUN apt-get clean all
RUN apt-get update
RUN apt-get upgrade -y

# Build Tools
RUN apt-get install -y build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev python

## Utilities & nginx
RUN apt-get install -y make wget tar git curl gcc libpcre3-dev libssl-dev

## Clean apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install NGINX
ENV NGINX_VERSION 1.8.0
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -xf nginx-${NGINX_VERSION}.tar.gz
RUN cd nginx-${NGINX_VERSION}/ && ./configure \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --with-http_ssl_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_stub_status_module \
  --with-http_auth_request_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-ipv6 \
  --with-http_spdy_module && \
  make && make install
RUN rm -rf nginx-${NGINX_VERSION}*
RUN mkdir /var/cache/nginx
ADD ./nginx.conf /etc/nginx/nginx.conf

ADD ./nginx-init.sh /etc/init.d/nginx
RUN chmod +x /etc/init.d/nginx

# App User
RUN useradd -ms /bin/bash app
RUN adduser app sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chmod 4755 /usr/bin/sudo
ENV HOME /home/app

# Don't run application as root
USER app

## Install Node
ENV NODE_VERSION 0.12.2
ENV PATH $HOME/local/bin:$PATH

RUN mkdir ~/local && mkdir ~/src && \
    cd ~/local && \
    curl http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz | tar xz --strip-components=1

EXPOSE 80

WORKDIR /home/app/src
