#!/bin/bash

set -ex

apt="apt"
if [[ -n $1 ]]; then
    apt="sudo apt"
fi

GO_VERSION="1.23.4"
FZF_VERSION="0.56.3"

packages=(
    zsh zsh-syntax-highlighting zsh-autosuggestions
    git zip unzip make cmake gcc g++ clang zoxide ripgrep fd-find yarn lldb python3-pip  python3-venv pkg-config nodejs eza npm tree-sitter-cli
    rustup
)

$apt install -y ${packages[@]}

# Install latest neovim
rm -rf nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
mv nvim-linux64 nvim
rm -rf nvim-linux64.tar.gz

# nvm
rm -rf .nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# fzf
curl -LO https://github.com/junegunn/fzf/releases/latest/download/fzf-${FZF_VERSION}-linux_amd64.tar.gz
tar -xzf fzf-${FZF_VERSION}-linux_amd64.tar.gz
mkdir -p bin
mv fzf bin/fzf
rm fzf-${FZF_VERSION}-linux_amd64.tar.gz

# Go
rm -rf go
curl -LO https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
tar -xzf go${GO_VERSION}.linux-amd64.tar.gz
rm go${GO_VERSION}.linux-amd64.tar.gz
go/bin/go env -w GOPATH=$HOME/dev

# starship
curl -LO https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz
tar -xzf starship-x86_64-unknown-linux-gnu.tar.gz
mkdir -p bin
mv starship bin/starship
rm starship-x86_64-unknown-linux-gnu.tar.gz
