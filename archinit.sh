# Enable network
systemctl enable --now NetworkManager

# Config network
nmtui

# neofetch time :)
pacman -S neofetch
neofetch

# Add multilib and archlinuxcn:
#
# [multilib]
# Include = /etc/pacman.d/mirrorlist
#
# [archlinuxcn]
# Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
# Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
vim /etc/pacman.conf

# Flush pacman
pacman -Syyu

# The normal user
useradd -m -G wheel -s /bin/bash wenqian
passwd wenqian
# Uncomment: %wheel ALL=(ALL:ALL) ALL
EDITOR=vim visudo

# Use new user to login.
logout

# Init archlinuxcn and install yay
sudo pacman-key --lsign-key "farseerfc@archlinux.org"
sudo pacman -S archlinuxcn-keyring
sudo pacman -S yay

# Some basic softwares
sudo pacman -S kitty tmux
sudo pacman -S nm-connection-editor
yay -S google-chrome
sudo pacman -S neovim
sudo pacman -S ttf-sourcecodepro-nerd adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S pulseaudio sof-firmware alsa-firmware alsa-ucm-conf pavucontrol # Audio
sudo pacman -S bluez bluez-utils blueman # Bluetooth

# Enable bluetooth (optional)
sudo systemctl enable --now bluetooth

# Install Intel GPU driver (for others, please refer to offical document):
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel

# Chinese Input Method
sudo pacman -S fcitx5-im
sudo pacman -S fcitx5-chinese-addons
sudo pacman -S fcitx5-material-color

# Add:
# GTK_IM_MODULE=fcitx
# QT_IM_MODULE=fcitx
# XMODIFIERS=@im=fcitx
# SDL_IM_MODULE=fcitx
# GLFW_IM_MODULE=ibus
sudo vim /etc/environment

# FUCK GFW:
sudo pacman -S v2ray v2raya
sudo systemctl enable --now v2raya
