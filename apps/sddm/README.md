# Install sddm theme

Install dependencies:

```bash
sudo pacman -S qt6-5compat qt6-declarative qt6-svg
```

Install theme:

```bash
sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
```

Replace config:

```bash
sudo cp ~/dotfiles/apps/sddm/sddm.conf /etc/sddm.conf
sudo cp ~/dotfiles/apps/sddm/theme.conf /usr/share/sddm/themes/sddm-astronaut-theme/theme.conf
```
