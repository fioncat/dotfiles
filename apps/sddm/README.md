# Install sddm theme

Install dependencies:

```bash
sudo pacman -S qt5-graphicaleffects qt5-svg qt5-quickcontrols2
```

Install theme:

```bash
git clone https://github.com/catppuccin/sddm.git /tmp/sddm
sudo mkdir -p /usr/share/sddm/themes
sudo mv /tmp/sddm/src/catppuccin-mocha /usr/share/sddm/themes
rm -rf /tmp/sddm
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
