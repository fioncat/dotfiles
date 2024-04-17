#!/bin/bash

ln -s ~/dotfiles/term/.tmux.conf ~/
ln -s ~/dotfiles/term/.tmux.conf.local ~/
ln -s ~/dotfiles/term/.zshrc ~/

ln -s ~/dotfiles/term/kitty ~/.config
ln -s ~/dotfiles/term/alacritty ~/.config
ln -s ~/dotfiles/term/wezterm ~/.config

# Softwares
sudo pacman -S fzf starship
sudo pacman -S sqlite3 ripgrep xclip zip unzip npm nodejs
sudo pacman -S bottom duf exa dust procs

# Oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Editor
sudo pacman -S neovim code
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fioncat/spacenvim/HEAD/scripts/install.sh)"

# Rust
sudo pacman -S rustup
rustup toolchain install stable
rustup component add clippy
rustup component add rust-analyzer
rustup component add rust-src

# Go
sudo pacman -S go
go install github.com/klauspost/asmfmt/cmd/asmfmt@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/kisielk/errcheck@latest
go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
go install github.com/rogpeppe/godef@latest
go install golang.org/x/tools/cmd/goimports@latest
go install golang.org/x/lint/golint@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/fatih/gomodifytags@latest
go install golang.org/x/tools/cmd/gorename@latest
go install github.com/jstemmer/gotags@latest
go install golang.org/x/tools/cmd/guru@latest
go install github.com/josharian/impl@latest
go install honnef.co/go/tools/cmd/keyify@latest
go install github.com/fatih/motion@latest
go install github.com/koron/iferr@latest

# Roxide
cargo install --git https://github.com/fioncat/roxide

# Docker
sudo pacman -S docker
sudo systemctl enable --now docker

# K8s
sudo pacman -S kubectl k9s
cargo install --git https://github.com/fioncat/kubeswitch
