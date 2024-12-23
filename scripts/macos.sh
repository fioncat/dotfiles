#!/bin/bash

set -eu

os_type=$(uname -s)
if [[ "$os_type" != "Darwin" ]]; then
  echo "Unsupported OS: $os_type"
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "Running as root is forbidden"
  exit 1
fi

create_link() {
  local src="$1"
  local dest="$2"
  if [[ -e $dest ]]; then
    rm -rf $dest
  fi
  ln -s $src $dest
}

check_commands_exist() {
  local commands=("$@")
  for cmd in "${commands[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "$cmd"
    fi
  done
}

packages=(
  zsh-autosuggestions zsh-syntax-highlighting
  starship eza fzf wezterm neovim lazygit ripgrep fd yarn make unzip node otree kubectl k9s wget make unzip fastfetch
  go rustup rustup-init
)

check_commands=(
  fzf starship rg fd go rustup kubectl k9s eza
)

if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:$PATH"
fi

uninstalled_packages=$(check_commands_exist "${check_commands[@]}")
if [[ -n "$uninstalled_packages" ]]; then
  echo "Found uninstalled binaries:"
  echo "$uninstalled_packages"

  echo "Begin to install packages"
  brew install "${packages[@]}"

  echo "Begin to install rust"
  rustup-init -y
  rustup toolchain install stable
  rustup component add clippy
  rustup component add rust-analyzer
  rustup component add rust-src
  export PATH="$HOME/.cargo/bin:$PATH"

  echo "Begin to install go tools"
  go install golang.org/x/tools/cmd/goimports@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/koron/iferr@latest

  echo "Begin to install roxide"
  cargo install --git https://github.com/fioncat/roxide

  echo "Begin to install kubewrap"
  go install github.com/fioncat/kubewrap@latest

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
