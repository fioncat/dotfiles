# NOTE: BASE_IMAGE only supports ArchLinux
ARG BASE_IMAGE="archlinux:latest"
FROM ${BASE_IMAGE}

MAINTAINER "Wenqian lazycat7706@gmail.com"

RUN pacman-key --init && pacman -Syu --noconfirm && pacman -S --noconfirm sudo

RUN useradd -m -G wheel -s /bin/bash wenqian && \
    echo "wenqian ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R wenqian:wenqian /home/wenqian

USER wenqian
WORKDIR /home/wenqian

COPY . dotfiles
RUN sudo pacman -S --noconfirm git base-devel go && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
RUN USER="wenqian" dotfiles/scripts/dev.sh --nodocker

ENTRYPOINT ["/usr/bin/zsh"]
