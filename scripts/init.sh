#!/bin/bash

GO_VERSION="1.23.4"
FZF_VERSION="0.56.3"

BIN_PATH="$HOME/bin"

set -e

mkdir -p $BIN_PATH
export PATH=$PATH:$BIN_PATH

is_root="false"
if [ "$(id -u)" -eq 0 ]; then
    echo "Running as root mode"
    is_root="true"
fi

pacman_mirrorlist="$(
cat <<EOT
Server = http://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch
EOT
)"

pacman_packages=(
    zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
    fzf starship neovim git lazygit ripgrep fd yarn lldb make zip unzip python-pynvim npm nodejs lua luajit eza bottom duf dust procs pkg-config curl openssh openssl wget fastfetch
    go rustup kubectl k9s
)

apt_mirrorlist="$(
cat <<EOT
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-proposed main restricted universe multiverse
EOT
)"

apt_packages=(
    zsh zsh-syntax-highlighting zsh-autosuggestions
    git zip unzip make cmake gcc g++ clang zoxide ripgrep fd-find yarn lldb python3-pip python3-venv pkg-config nodejs npm curl
)

brew_packages=()

function install_archlinux() {
    local pacman="pacman --noconfirm"
    local pacman_key="pacman-key"
    if [[ "$is_root" != "true" ]]; then
        pacman="sudo $pacman"
        pacman_key="sudo $pacman_key"
    fi

    if [[ "$is_root" == "true" ]]; then
        echo "Replace pacman mirrorlist"
        mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.back
        echo "$pacman_mirrorlist" > /etc/pacman.d/mirrorlist
    fi

    echo "Instaling pacman packages..."
    $pacman_key --init
    $pacman -Syu
    $pacman -S ${pacman_packages[@]}

    install_rust
}

function install_ubuntu() {
    local apt="apt"
    if [[ "$is_root" != "true" ]]; then
        apt="sudo apt"
    fi

    if [[ "$is_root" == "true" ]]; then
        echo "Replace apt sourcelist"
        mv /etc/apt/sources.list /etc/apt/sources.list.back
        echo "$apt_mirrorlist" > /etc/apt/sources.list
    fi

    echo "Installing apt packages..."
    $apt update
    $apt install -y ${apt_packages[@]}

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    export PATH=$PATH:$HOME/.cargo/bin
    cargo install --locked tree-sitter-cli
    rm -f $HOME/.zshenv

    install_eza
    install_fzf
    install_go
    install_starship
    install_nvim
}

function install_fzf() {
    echo "Installing fzf..."
    download_github_release "junegunn" "fzf" "fzf-${FZF_VERSION}-linux_amd64.tar.gz"
    mv fzf $BIN_PATH/fzf
}

function install_go() {
    echo "Installing go..."
    local name="go${GO_VERSION}.linux-amd64.tar.gz"
    curl -LO https://go.dev/dl/$name
    tar -xzf $name -C $HOME
    rm $name

    GO_BIN="$HOME/go/bin"
    export PATH=$PATH:$GO_BIN

    go env -w GOPATH=$HOME/dev
}

function install_starship() {
    echo "Installing starship..."
    download_github_release "starship" "starship" "starship-x86_64-unknown-linux-gnu.tar.gz"
    mv starship $BIN_PATH/starship
}

function install_roxide() {
    echo "Installing roxide..."
    download_github_release "fioncat" "roxide" "roxide-x86_64-unknown-linux-gnu.tar.gz"
    mv roxide $BIN_PATH/roxide
}

function install_eza() {
    echo "Installing eza..."
    download_github_release "eza-community" "eza" "eza_x86_64-unknown-linux-gnu.tar.gz"
    mv eza $BIN_PATH/eza
}

function install_nvim() {
    echo "Installing neovim..."
    download_github_release "neovim" "neovim" "nvim-linux64.tar.gz"
    mv nvim-linux64 $HOME/nvim
    export PATH=$PATH:$HOME/nvim/bin
}

function download_github_release() {
    local owner="$1"
    local repo="$2"
    local name="$3"

    local url="https://github.com/$owner/$repo/releases/latest/download/$name"
    curl -LO "$url"

    tar -xzf "$name"
    rm "$name"
}

function install_rust() {
    echo "Installing rust..."
    rustup toolchain install stable
    rustup component add clippy
    rustup component add rust-analyzer
    rustup component add rust-src
}

function install_go_tools() {
    echo "Installing go tools..."
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/fatih/gomodifytags@latest
    go install github.com/koron/iferr@latest
}

function install_nvim_config() {
    if [[ -d $HOME/.config/nvim ]]; then
        echo "neovim config already exists, skip installing"
        return
    fi

    echo "Installing neovim plugins..."
    git clone https://github.com/fioncat/spacenvim.git $HOME/.config/nvim
    nvim --headless "+Lazy! sync" +qa
    echo "Initializing neovim tree-sitter..."
    nvim --headless $HOME/.config/nvim/init.lua -c "TSUpdateSync" +qa
    echo "Initializing neovim lsp..."
    nvim --headless $HOME/.config/nvim/init.lua -c "MasonInstall gopls rust-analyzer" +qa
    nvim --headless $HOME/.config/nvim/init.lua -c "MasonInstall bash-language-server html-lsp json-lsp lua-language-server python-lsp-server" +qa
}

function create_link() {
    local src="$1"
    local dest="$2"
    if [[ -e $dest ]]; then
        return
    fi
    ln -s $src $dest
}

os_type=$(uname -s)

case $os_type in
    "Linux")
        if [[ -f /etc/arch-release ]]; then
            echo "Arch Linux detected"
            linux_type="archlinux"
            install_archlinux
        elif [[ -f /etc/lsb-release ]]; then
            . /etc/lsb-release
            if [ "$DISTRIB_ID" == "Ubuntu" ]; then
                echo "Ubuntu detected"
                linux_type="ubuntu"
                install_ubuntu
            fi
        fi
        if [[ -z $linux_type ]]; then
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
    "Darwin")
        install_brew
        ;;
    *)
        echo "Unsupported OS: $os_type"
        exit 1
        ;;
esac

install_roxide
install_go_tools

echo "Setup config"
create_link $HOME/dotfiles/term/zsh/zshrc $HOME/.zshrc
create_link $HOME/dotfiles/term/zsh/zshenv $HOME/.zshenv
mkdir -p $HOME/.config
create_link $HOME/dotfiles/apps/lazygit $HOME/.config/lazygit
create_link $HOME/dotfiles/apps/roxide $HOME/.config/roxide
create_link $HOME/dotfiles/apps/starship.toml $HOME/.config/starship.toml

install_nvim_config
