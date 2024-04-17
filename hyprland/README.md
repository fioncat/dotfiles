# Hyprland

Install:

```bash
sudo pacman -S hyprland hyprpaper hyprlock waybar mako
yay -S rofi-lbonn-wayland-git # The rofi for Wayland
```

> Please donot use rofi directly since it has issues on hyprland

The [xorg-xwayland](https://archlinux.org/packages/extra/x86_64/xorg-xwayland/) is required to run `X11` applications:

```bash
sudo pacman -S xorg-xwayland
```

Please add yourself to input group to let `waybar` can listen to keyboard events:

```bash
sudo usermod -a -G input $USER
```

Import my config:

```bash
git clone https://github.com/fioncat/dotfiles.git ~/
ln -s ~/dotfiles/hyprland/hypr ~/.config
ln -s ~/dotfiles/hyprland/mako ~/.config
ln -s ~/dotfiles/hyprland/rofi ~/.config
ln -s ~/dotfiles/hyprland/waybar ~/.config
```

Install sddm and start Hyprland:

```bash
sudo pacman -S sddm
sudo systemctl enable sddm

# If you are ready, leave the tty!!!
sudo systemctl start sddm
```

## Run in Xwayland?

If you want to know which applications run natively in wayland and which ones run in xwayland, please use:

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

## Change the theme

Use lxappearance:

```bash
sudo pacman -S lxappearance
```

Install some themes:

```bash
sudo pacman -S materia-gtk-theme papirus-icon-theme
```

## File Manager

[Thunar](https://archlinux.org/packages/extra/x86_64/thunar/), a lightweight file manager for Xfce:

```bash
sudo pacman -S thunar
```

## Picture Viewer

[Ristretto](https://archlinux.org/packages/extra/x86_64/ristretto/), a lightweight picture viewer for Xfce:

```bash
sudo pacman -S ristretto
```

## Mail and Calendar

Recommended to use [Thunderbird](https://www.thunderbird.net/):

```bash
sudo pacman -S thunderbird
```

Chinese holidays subscription: `https://mtjo.net/icalendar/holidays.ics`.

## Have problem pairing bluetooth keyboard?

The blueman cannot pair HHKB keyboard directly, because it won't show **PIN code** during pairing (maybe a Wayland or WM problem?), we need to use `bluetoothctl` command to pair HHKB manually.

First of all, we need to stop the running blueman manager:

```bash
killall blueman-applet
```

If the process does not exit normally, you may need to restart the computer, don't forget to remove the `blueman-applet` auto start command in `Hyprland`:

```
# Remove this line
exec-once = blueman-applet
```

Use `bluetoothctl` to scan devices, more details please refer to [wiki](https://wiki.archlinux.org/title/bluetooth#Pairing).

Put your HHKB Keyboard into pairing mode. Then run the following commands (you may need another wired keyboard lol...):

```bash
bluetoothctl

# Enter bluetoothctl prompt
agent KeyboardOnly
default-agent
power on
scan on
# Lots of devices and their MAC addresses will be listed, please locate HHKB Keyboard.
# The name should be like "HHKB-Hybrid_1"
pair xxx  # Input the HHKB Keyboard MAC Address.
```

You will find the following output:

```
Request PIN code
[agent] Enter PIN code: ****
```

Now you need to use your HHKB Keyboard to input the PIN code seeing above, then the pairing will be done.

> The blueman manager in Hyprland cannot show this PIN code, so the keyboard pairing won't stop.

Exit `bluetoothctl`, test your keyboard, and now you can still use blueman to configure your devices. The keyboard should be auto connected after you restarting computer.
