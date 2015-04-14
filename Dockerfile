FROM ubuntu:trusty
MAINTAINER Christian Bankester <cbankester@immense.net>

## Prepare
RUN apt-get clean all
RUN apt-get update
RUN apt-get upgrade -y

# Build Tools
RUN apt-get install -y build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev

## Utilities & nginx
RUN apt-get install -y make wget tar git curl

## Clean apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

ONBUILD ADD . /home/app/src
ONBUILD RUN npm install
ONBUILD RUN sudo chown -R app /home/app/src
