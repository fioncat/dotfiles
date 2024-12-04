#!/bin/bash

function init_archlinux() {
    echo "Begin to init ArchLinux"
    packages=(
        zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
        fzf starship neovim git lazygit ripgrep fd yarn lldb make zip unzip python-pynvim npm nodejs tree-sitter-cli lua luajit bottom duf eza dust procs pkg-config curl
        go rustup kubectl k9s
    )

    pacman-key --init
    pacman -Syu --noconfirm

    pacman -S --noconfirm ${packages[@]}
}

function init_ubuntu() {
    echo "Begin to init Ubuntu"
}

function init_darwin() {
    echo "Begin to init Darwin"
}

OS_TYPE=$(uname -s)

if [ "$OS_TYPE" == "Linux" ]; then
    if [ -f /etc/arch-release ]; then
        init_archlinux
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        if [ "$DISTRIB_ID" == "Ubuntu" ]; then
            init_ubuntu
        fi
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
elif [ "$OS_TYPE" == "Darwin" ]; then
    init_darwin
else
    echo "Unsupported operating system: $OS_TYPE"
    exit 1
fi

go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/koron/iferr@latest

rustup toolchain install stable
rustup component add clippy
rustup component add rust-analyzer
rustup component add rust-src

# Install roxide
curl --fail --location -o roxide.tgz https://github.com/fioncat/roxide/releases/latest/download/roxide-x86_64-unknown-linux-gnu.tar.gz
tar -xzvf roxide.tgz
mkdir -p bin
mv roxide bin/roxide
rm roxide.tgz
