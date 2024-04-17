# Hyprland

See: [install.sh](install.sh)

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
