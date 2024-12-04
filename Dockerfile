ARG BASE_IMAGE="archlinux:latest"
FROM ${BASE_IMAGE}

MAINTAINER "Wenqian lazycat7706@gmail.com"
WORKDIR /root

COPY scripts/init.sh init.sh
RUN /bin/bash init.sh && rm init.sh

COPY term/zsh/zshrc .zshrc
COPY term/zsh/zshenv .zshenv
RUN chsh -s /usr/bin/zsh

COPY apps/k9s .config/k9s
COPY apps/lazygit .config/lazygit
COPY apps/roxide .config/roxide
COPY apps/starship.toml .config/starship.toml

ENTRYPOINT ["/usr/bin/zsh", "-l"]
