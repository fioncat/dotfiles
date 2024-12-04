#!/bin/bash

set -ex

pacman_key="pacman-key"
pacman="pacman"
if [[ -n $1 ]]; then
    pacman_key="sudo pacman-key"
    pacman="sudo pacman"
fi

packages=(
    zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
    fzf starship neovim git lazygit ripgrep fd yarn lldb make zip unzip python-pynvim npm nodejs tree-sitter-cli lua luajit bottom duf eza dust procs pkg-config curl
    go rustup kubectl k9s
)

$pacman_key --init
$pacman -Syu --noconfirm

$pacman -S --noconfirm ${packages[@]}
