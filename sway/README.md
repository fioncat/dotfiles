# Sway

Install:

```bash
sudo pacman -S sway swaybg swaylock-effects waybar
sudo pacman -S wl-clipboard  # Clipboard support for wayland
sudo pacman -S dmenu foot  # The default menu and terminal for sway
```

Please add yourself to `input` group to let swaybar can listen to keyboard events:

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
swaymsg -t get_tree
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
