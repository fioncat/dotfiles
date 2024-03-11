# i3wm

## Install

Install i3wm:

```bash
sudo pacman -S xorg i3-wm polybar i3lock-color feh picom
sudo pacman -S xclip flameshot
```

Start:

```bash
sudo systemctl start sddm
```

## Screen Saver

See: [Display Power Management Signaling](https://wiki.archlinux.org/title/Display_Power_Management_Signaling).

You can use the following commands to turn off screen saver:

```bash
xset s off
xset -dpms
```

Display the changes:

```bash
xset q
```
