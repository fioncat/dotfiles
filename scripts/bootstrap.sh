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

pacman="sudo pacman --noconfirm"
yay="yay --noconfirm"

if ! command -v yay &> /dev/null; then
  echo "Begin to install archlinuxcn and yay"

  sudo tee -a /etc/pacman.conf > /dev/null << EOF
[multilib]
Include = /etc/pacman.d/mirrorlist

[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
EOF

  $pacman -Syyu
  $pacman -S archlinuxcn-keyring
  $pacman -S yay
else
  echo "archlinuxcn and yay already installed, skip"
fi

if [[ ! -d $HOME/Downloads ]]; then
  $pacman -S xdg-user-dirs
  echo "Ensure some default directories"
  cd $HOME
  xdg-user-dirs-update
fi

basic_packages=(
  hyprland hyprpaper hyprlock waybar mako rofi-wayland xorg-xwayland
  kitty nm-connection-editor
  xdg-desktop-portal-hyprland grim

  # Fonts
  ttf-sourcecodepro-nerd adobe-source-han-serif-cn-fonts wqy-zenhei
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

  # Audio
  pulseaudio sof-firmware alsa-firmware alsa-ucm-conf pavucontrol

  # Bluetooth
  bluez bluez-utils blueman

  # Input method
  fcitx5-im fcitx5-chinese-addons fcitx5-material-color

  # Clipboard
  wl-clipboard cliphist

  # Some GUI software
  thunar ristretto thunderbird okular

  sddm
)

yay_packages=(
  google-chrome wezterm-git flameshot-git
)

if ! command -v Hyprland &> /dev/null; then
  echo "Begin to install basic packages"
  $pacman -S ${basic_packages[@]}
  $yay -S ${yay_packages[@]}

  mkdir -p $HOME/.config
  ln -s $HOME/dotfiles/hyprland/hypr $HOME/.config
  ln -s $HOME/dotfiles/hyprland/rofi $HOME/.config
  ln -s $HOME/dotfiles/hyprland/mako $HOME/.config
  ln -s $HOME/dotfiles/hyprland/waybar $HOME/.config
  ln -s $HOME/dotfiles/term/wezterm $HOME/.config
  ln -s $HOME/dotfiles/term/kitty $HOME/.config

  sudo systemctl enable sddm
  sudo systemctl enable --now bluetooth

  echo "Bootstrap completed, you can reboot to enter Hyprland."
  echo "Next steps: 1) install proxy. 2) install dev."

else
  echo "Hyprland already installed, skip"
fi
