# dotfiles

## Arch Linux

In archiso:

```bash
# Donot let reflector auto change our pacman mirrors.
systemctl stop reflector.service

# Ensure that we are in UEFI mode.
ls /sys/firmware/efi/efivars

# Connect wifi (optional)
iwctl # connect wifi

# Make sure that archiso has connected to Internet.
curl http://baidu.com

# Update the system clock
timedatectl set-ntp true
timedatectl status

# Change the mirrors to China.
vim /etc/pacman.d/mirrorlist

# Confirm disk and do the partition.
lsblk
cfdisk /dev/xxx

# Format our new partitions.
mkfs.vfat -F32 /dev/xxx1
mkswap /dev/xxx2
mkfs.ext4 /dev/xxx3

# Mount all the partitions.
mount /dev/xxx3 /mnt
mkdir /mnt/boot
mount /dev/xxx1 /mnt/boot
swapon /dev/xxx2
df -h
free -h

# Install archlinux
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt networkmanager vim sudo zsh zsh-completions

# Generate fstab
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab

# Switch to the new system
arch-chroot /mnt

# Edit the hostname
vim /etc/hostname

# Edit localhost DNS
# Set to this: (`myarch` is your hostname)
# 127.0.0.1   localhost
# ::1         localhost
# 127.0.1.1   myarch.localdomain myarch
vim /etc/hosts

# Set time zone.
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Sync time to hardware.
hwclock --systohc

# Config locale, uncomment `en_US.UTF-8 UTF-8`.
vim /etc/locale.gen

# Setup locale.
locale-gen
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf

# Set password for root
passwd root

# The ucode
pacman -S intel-ucode
# AMD: pacman -S amd-ucode

# Install and config Grub
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
# Edit grub config `GRUB_CMDLINE_LINUX_DEFAULT`:
# - Remove `-quiet`.
# - Set `loglevel` to `5`.
# - Add `nowatchdog`.
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Exit archiso and restart, enter the new system
exit
umount -R /mnt
reboot
```

In new system:

```bash
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
sudo pacman -S wezterm
sudo pacman -S thunar
sudo pacman -S nm-connection-editor
sudo pacman -S google-chrome
sudo pacman -S neovim
sudo pacman -S sof-firmware alsa-firmware alsa-ucm-conf
sudo pacman -S ttf-sourcecodepro-nerd adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S pulseaudio sof-firmware alsa-firmware alsa-ucm-conf # Audio
sudo pacman -S bluz bluez-utils blueman # Bluetooth

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

# Some common softwares for wms:
sudo pacman -S sddm
sudo systemctl enable sddm
sudo pacman -S rofi
```

WMs:

I use [Tiling Window Manager](https://en.wikipedia.org/wiki/Tiling_window_manager):

- [Sway (Wayland)](https://swaywm.org/): [My config](sway)
- [i3wm (X11)](https://i3wm.org/): [My config](i3wm)

The sway has a much better performance, but some softwares might not work (like [flameshot](https://flameshot.org/)).

> TIPs:
>
> - If you have NVIDIA GPU, please use `i3wm`.
> - If you want to use some wine apps, like WeChat, please use `i3wm`.
> - In other cases, please use `sway`.

Some other famous tiling WMs:

- [Hyprland (Wayland)](https://hyprland.org/)
- [Awesome (X11)](https://awesomewm.org/)
- [bspwm (X11)](https://github.com/baskerville/bspwm)
- [dwm (X11)](https://dwm.suckless.org/)


If you donot like tiling WMs, you can also install [KDE Plasma](https://kde.org/plasma-desktop/):

```bash
sudo pacman -S plasma-meta konsole dolphin
sudo systemctl start sddm
```
