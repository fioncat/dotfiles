#!/bin/bash

# Check if running as root
if [[ $EUID -eq 0 ]]; then
  echo "Error: This script should not be run as root"
  exit 1
fi

# Show help message
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Development Environment Setup Script"
  echo
  echo "Usage: setup.sh [options]"
  echo
  echo "Options:"
  echo "  -h, --help    Display this help message again"
  echo
  echo "This script will:"
  echo "  - Check system requirements (Arch Linux and macOS only)"
  echo "  - Verify required package managers (pacman/yay or brew)"
  echo "  - Install and configure Python environment"
  echo "  - Install required packages"
  echo "  - Install Rust toolchain"
  echo "  - Initialize development environment"
  exit 0
fi

set -eu

# Check system and package managers
system=$(uname -s | tr '[:upper:]' '[:lower:]')

if [[ "$system" == "linux" ]]; then
  # Check if it's Arch Linux
  if [[ ! -f "/etc/arch-release" ]]; then
    echo "Error: Only Arch Linux is supported on Linux"
    exit 1
  fi

  # Check if pacman exists
  if ! command -v pacman &> /dev/null; then
    echo "Error: pacman is not installed"
    exit 1
  fi

  # Check if yay exists
  if ! command -v yay &> /dev/null; then
    echo "Error: yay is not installed"
    exit 1
  fi
elif [[ "$system" == "darwin" ]]; then
  # Check if brew exists
  if ! command -v brew &> /dev/null; then
    echo "Error: brew is not installed"
    exit 1
  fi
else
  echo "Error: Unsupported system: $system"
  exit 1
fi

# Check if python3 exists
if ! command -v python3 &> /dev/null; then
  if [[ "$system" == "linux" ]]; then
    echo "Installing python3..."
    sudo pacman -S --noconfirm python
  else
    echo "Error: python3 is not installed. On macOS, python3 should be pre-installed"
    exit 1
  fi
fi

echo "Sync packages..."
python3 ~/dotfiles/scripts/syncpkg.py

# Check if cargo exists
if ! cargo &> /dev/null; then
  echo "Installing rust..."
  if command -v rustup-init &> /dev/null; then
    rustup-init -y
  elif command -v rustup &> /dev/null; then
    rustup toolchain install stable
    rustup component add clippy
    rustup component add rust-analyzer
    rustup component add rust-src
  else
    echo "Error: rustup or rustup-init is not installed"
    exit 1
  fi
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Check if goimports exists
if ! command -v goimports &> /dev/null; then
  echo "Installing go tools..."
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/koron/iferr@latest
fi

if ! command -v roxide &> /dev/null; then
  echo "Installing roxide..."
  cargo install --git https://github.com/fioncat/roxide
fi

if ! command -v kubewrap &> /dev/null; then
  echo "Installing kubewrap..."
  go install github.com/fioncat/kubewrap@latest
fi

if [[ "$system" == "linux" ]] && [[ ! " $@ " =~ " --nodocker " ]]; then
  if ! systemctl is-enabled docker &> /dev/null; then
    echo "Enabling docker service..."
    sudo systemctl enable --now docker
  fi
else
  echo "Skip docker service"
fi

# Set default shell to zsh if not already
if [[ $(basename $SHELL) != "zsh" ]]; then
  echo "Setting default shell to zsh..."
  if command -v zsh &> /dev/null; then
    sudo chsh -s $(which zsh) $USER
  else
    echo "Error: zsh is not installed"
    exit 1
  fi
fi

create_link() {
  local target="$1"
  local link="$2"
  if [[ -e "$link" ]]; then
    echo "Link $link already exists, skip"
    return
  fi
  echo "Creating symlink $target -> $link"
  ln -s "$target" "$link"
}

mkdir -p $HOME/.config

create_link $HOME/dotfiles/term/zsh/zshrc $HOME/.zshrc
create_link $HOME/dotfiles/term/zsh/zshenv $HOME/.zshenv
create_link $HOME/dotfiles/term/wezterm $HOME/.config/wezterm
create_link $HOME/dotfiles/term/kitty $HOME/.config/kitty
create_link $HOME/dotfiles/term/alacritty $HOME/.config/alacritty

create_link $HOME/dotfiles/apps/lazygit $HOME/.config/lazygit
create_link $HOME/dotfiles/apps/roxide $HOME/.config/roxide
create_link $HOME/dotfiles/apps/starship.toml $HOME/.config/starship.toml
create_link $HOME/dotfiles/apps/kubewrap $HOME/.config/kubewrap

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

echo ""
echo ""
echo ""
echo "██╗      █████╗ ███████╗██╗   ██╗ ██████╗ █████╗ ████████╗"
echo "██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██╔════╝██╔══██╗╚══██╔══╝"
echo "██║     ███████║  ███╔╝  ╚████╔╝ ██║     ███████║   ██║   "
echo "██║     ██╔══██║ ███╔╝    ╚██╔╝  ██║     ██╔══██║   ██║   "
echo "███████╗██║  ██║███████╗   ██║   ╚██████╗██║  ██║   ██║   "
echo "╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝╚═╝  ╚═╝   ╚═╝   "
echo ""
echo ""
echo ""
echo "       Done. Please restart your terminal :)              "
