# Install sddm theme

Install dependencies:

```bash
sudo pacman -Syu qt5-graphicaleffects qt5-svg qt5-quickcontrols2
```

Install theme:

```bash
sudo cp -r themes/catppuccin-mocha /usr/share/sddm/themes
```

Update config:

```bash
sudo vim /etc/sddm.conf
```

Add:

```ini
[Theme]
Current=catppuccin-mocha
```
