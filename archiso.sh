# Donot let reflector auto change our pacman mirrors.
systemctl stop reflector.service

# Ensure that we are in UEFI mode.
ls /sys/firmware/efi/efivars

# Connect wifi (optional)
iwctl

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
