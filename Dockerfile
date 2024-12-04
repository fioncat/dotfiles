ARG BASE_IMAGE="archlinux:latest"
FROM ${BASE_IMAGE}

MAINTAINER "Wenqian lazycat7706@gmail.com"

RUN pacman-key --init
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
RUN pacman -S --noconfirm fzf starship neovim git lazygit ripgrep fd yarn lldb make zip unzip python-pynvim npm nodejs tree-sitter-cli lua luajit bottom duf exa dust procs

# Go
RUN pacman -S --noconfirm go
RUN go install golang.org/x/tools/cmd/goimports@latest
RUN go install github.com/fatih/gomodifytags@latest
RUN go install github.com/koron/iferr@latest

# Rust
RUN pacman -S --noconfirm rustup
RUN rustup toolchain install stable
RUN rustup component add clippy
RUN rustup component add rust-analyzer
RUN rustup component add rust-src

# Kubernetes
RUN pacman -S --noconfirm kubectl k9s

# Roxide
RUN pacman -S --noconfirm pkg-config
RUN cargo install --git https://github.com/fioncat/roxide

COPY term/zsh/zshrc /root/.zshrc
COPY term/zsh/zshenv /root/.zshenv
RUN chsh -s /usr/bin/zsh

ENTRYPOINT ["/usr/bin/zsh", "-l"]
