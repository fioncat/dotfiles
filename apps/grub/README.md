# Grub Theme

Install the theme:

```bash
mkdir Distro
tar -xf archlinux.tar -C ./Distro
sudo mv ./Distro /usr/share/grub/themes
```

Change the theme:

```bash
sudo vim /etc/default/grub
```

Add the line:

```ini
GRUB_THEME="/usr/share/grub/themes/Distro/theme.txt"
```

Flush grub:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
