# Hyprland

Install:

```bash
sudo pacman -S hyprland hyprpaper swaylock waybar
```

Please add yourself to input group to let `waybar` can listen to keyboard events:

```bash
sudo usermod -a -G input $USER
```

## Xwayland

The [xorg-xwayland](https://archlinux.org/packages/extra/x86_64/xorg-xwayland/) is required to run `X11` applications:

```bash
sudo pacman -S xorg-xwayland
```

If you want to know which applications run natively in wayland and which ones run in xwayland, please run:

```bash
hyprctl clients
```

## Screenshot

Use `grim` + `slurp` + `swappy`:

```bash
sudo pacman -S grim slurp swappy
```

Take screenshot:

```bash
grim -g "$(slurp)" - | swappy -f -
```

## Clipboard

Install Wayland Clipboard Support:

```bash
sudo pacman -S wl-clipboard
```

Install [cliphist](https://archlinux.org/packages/extra/x86_64/cliphist/) to store and manage clipboard history:

```bash
sudo pacman -S cliphist
```

Add this to hyprland config:

```
exec-once = wl-paste --watch cliphist store &
```

Use rofi to search clipboard history:

```bash
rofi -modi clipboard:~/dotfiles/apps/rofi/bin/rofi-cliphist -show clipboard
```

More please refer to: [cliphist](https://github.com/sentriz/cliphist?tab=readme-ov-file#picker-examples).

## Change the theme

Use lxappearance:

```bash
sudo pacman -S lxappearance
```

Install some themes:

```bash
sudo pacman -S materia-gtk-theme papirus-icon-theme
```
