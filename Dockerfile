# BASE_IMAGE only supports ArchLinux or Ubuntu 22.04+
ARG BASE_IMAGE="archlinux:latest"
FROM ${BASE_IMAGE}

MAINTAINER "Wenqian lazycat7706@gmail.com"
WORKDIR /root

COPY . dotfiles
RUN bash dotfiles/scripts/init.sh

ENTRYPOINT ["/usr/bin/zsh"]
