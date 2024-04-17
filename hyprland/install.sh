#!/bin/bash

# archlinuxcn and yay
sudo pacman-key --lsign-key "farseerfc@archlinux.org"
sudo pacman -S archlinuxcn-keyring
sudo pacman -S yay

# Setup configs
sudo pacman -S git
git clone https://github.com/fioncat/dotfiles.git ~/
ln -s ~/dotfiles/hyprland/hypr ~/.config
ln -s ~/dotfiles/hyprland/mako ~/.config
ln -s ~/dotfiles/hyprland/rofi ~/.config
ln -s ~/dotfiles/hyprland/waybar ~/.config

# Basic softwares
sudo pacman -S hyprland hyprpaper hyprlock waybar mako
yay -S rofi-lbonn-wayland-git
sudo pacman -S xorg-xwayland

# Terminal
sudo pacman -S kitty tmux

# Network Manager
sudo pacman -S nm-connection-editor

# Chrome
yay -S google-chrome

# Fonts
sudo pacman -S ttf-sourcecodepro-nerd adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

# Audio
sudo pacman -S pulseaudio sof-firmware alsa-firmware alsa-ucm-conf pavucontrol

# Bluetooth
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable --now bluetooth

# Chinese input method
sudo pacman -S fcitx5-im
sudo pacman -S fcitx5-chinese-addons
sudo pacman -S fcitx5-material-color

# Install Intel GPU driver (for others, please refer to offical document):
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel

# Screenshot
sudo pacman -S grim slurp swappy

# Clipboard history
sudo pacman -S wl-clipboard cliphist

# GTK theme
sudo pacman -S lxappearance
sudo pacman -S materia-gtk-theme papirus-icon-theme

# QT theme
sudo pacman -S qt5ct qt5-wayland

# FUCK GFW
sudo pacman -S v2ray v2raya
sudo systemctl enable --now v2raya

# File Manager
sudo pacman -S thunar

# Picture Viewer
sudo pacman -S ristretto

# Mail and Calendar
sudo pacman -S thunderbird

# SDDM
sudo pacman -S sddm
sudo systemctl enable sddm
