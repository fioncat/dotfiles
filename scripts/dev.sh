#!/bin/bash

set -eu

os_type=$(uname -s)
if [[ "$os_type" != "Linux" ]]; then
  echo "Unsupported OS: $os_type"
  exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
  echo "Not an Arch Linux distribution"
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "Running as root is forbidden"
  exit 1
fi

function create_link() {
  local src="$1"
  local dest="$2"
  if [[ -e $dest ]]; then
    rm -rf $dest
  fi
  ln -s $src $dest
}

pacman="sudo pacman --noconfirm"

dev_packages=(
  zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
  fzf starship neovim git lazygit ripgrep fd yarn lldb make zip unzip python-pynvim npm nodejs lua luajit eza bottom duf dust procs pkg-config curl openssh openssl wget fastfetch jq bc
  go rustup kubectl k9s clang gcc docker docker-compose
)

# TODO: Check more binaries
if ! command -v cargo &> /dev/null; then
  echo "Begin to install dev packages"
  $pacman -S ${dev_packages[@]}

  sudo systemctl enable --now docker

  echo "Begin to install rust"
  rustup toolchain install stable
  rustup component add clippy
  rustup component add rust-analyzer
  rustup component add rust-src

  echo "Begin to install go tools"
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/koron/iferr@latest

  echo "Begin to install roxide"
  cargo install --git https://github.com/fioncat/roxide

  echo "Begin to install kubewrap"
  go install github.com/fioncat/kubewrap@latest

  echo "Change default shell to zsh"
  chsh -s $(which zsh)

  create_link $HOME/dotfiles/term/zsh/zshrc $HOME/.zshrc
  create_link $HOME/dotfiles/term/zsh/zshenv $HOME/.zshenv

  mkdir -p $HOME/.config
  create_link $HOME/dotfiles/apps/lazygit $HOME/.config/lazygit
  create_link $HOME/dotfiles/apps/roxide $HOME/.config/roxide
  create_link $HOME/dotfiles/apps/starship.toml $HOME/.config/starship.toml
  create_link $HOME/dotfiles/apps/kubewrap $HOME/.config/kubewrap
else
  echo "dev packages has already been installed, skip"
fi

if [[ ! -d $HOME/.config/nvim ]]; then
  echo "Begin to install neovim configs"
  git clone https://github.com/fioncat/spacenvim.git $HOME/.config/nvim
  nvim --headless "+Lazy! sync" +qa
  nvim --headless $HOME/.config/nvim/init.lua -c "TSUpdateSync" +qa
  nvim --headless $HOME/.config/nvim/init.lua -c "MasonInstall gopls rust-analyzer" +qa
  nvim --headless $HOME/.config/nvim/init.lua -c "MasonInstall bash-language-server html-lsp json-lsp lua-language-server python-lsp-server" +qa
else
  echo "neovim configs has already been installed, skip"
fi

echo "Done!!! Please restart your terminal~"
