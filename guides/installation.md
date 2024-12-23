# Installation Guide

References:

- [Arch Wiki](https://wiki.archlinux.org/title/Installation_guide).
- [archlinux 简明指南](https://arch.icekylin.online/)

## Boot from live environment

Download archlinux iso file from: [Download page](https://archlinux.org/download/).

You can use [etcher](https://etcher.balena.io/) to create USB flash device.

## Disable reflector

Disable the reflector to prevent the mirror from auto-updating:

```bash
systemctl stop reflector
```

## Ensure Internet connected

```bash
curl http://baidu.com
```

## Update the system clock

```bash
timedatectl set-ntp true
timedatectl status
```

## Update pacman mirror

Edit `/etc/pacman.d/mirrorlist`:

```
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
```

## Partition the disks

Please refer to: [Example layouts](https://wiki.archlinux.org/title/Installation_guide#Example_layouts).

```bash
lsblk
cfdisk /dev/your_main_disk
```

## Format the partitions

```bash
mkfs.fat -F32 /dev/boot_partition
mkfs.ext4 /dev/root_partition
mkswap /dev/swap_partition # Optional
mkfs.ext4 /dev/home_partition # Optional
```

## Mount the file systems

```bash
mount /dev/root_partition /mnt
mount --mkdir /dev/boot_partition /mnt/boot
swapon /dev/swap_partition # Optional
mount --mkdir /dev/home_partition /mnt/home # Optional
```

## Installation

```bash
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt networkmanager vim sudo zsh zsh-completions
```

If pacstrap reports GPG error, execute:

```bash
pacman -S archlinux-keyring
```

## Generate fstab

```bash
genfstab -U /mnt > /mnt/etc/fstab
cat /mnt/etc/fstab
```

## Configure the system

```bash
arch-chroot /mnt

# Set hostname
vim /etc/hostname
# 127.0.0.1 localhost
# ::1       localhost
# 127.0.0.1 your_hostname.localdomain your_hostname
vim /etc/hosts

# time zone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

hwclock --systohc

# Uncomment: en_US.UTF-8 UTF-8
vim /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8"  > /etc/locale.conf

# Set password for root
passwd root

# Install ucode
pacman -S intel-ucode # Intel
pacman -S amd-ucode # AMD

# Install boot loader
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5 nowatchdog"
# GRUB_DISABLE_OS_PROBER=false (Optional, if you need to boot Windows)
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Normal user
useradd -m -G wheel -s /bin/bash your_user
passwd your_user
# Uncomment: %wheel ALL=(ALL:ALL) ALL
EDITOR=vim visudo

# Complete installation
exit
umount -R /mnt
reboot
```
