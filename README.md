# dotfiles

Powered by:

- OS: [Arch Linux](https://archlinux.org/)
- WM: [Hyprland](https://hyprland.org/)
- Terminal: [WezTerm](https://wezfurlong.org/wezterm/index.html)
- Editor: [Neovim](https://neovim.io/)
- Theme: [Catppuccin](https://github.com/catppuccin/catppuccin)

Inspired by [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland).

## Guides

Arch Linux:

1. [Installation](guides/installation.md)
2. Ensure your network is available: `sudo systemctl enable --now NetworkManager`
3. Install git: `sudo pacman -S git`
4. Clone this repository to home directory: `git clone https://github.com/fioncat/dotfiles.git ~/dotfiles`
5. Run bootstrap script: `~/dotfiles/scripts/bootstrap.sh`
6. Install graphic driver, see: [GPU](guides/GPU.md)
7. Reboot your system to enter Hyprland
8. Run proxy script and config it (if you are in GWF): `~/dotfiles/scripts/proxy.sh`
9. Run setup script: `~/dotfiles/scripts/setup.sh`
10. Run secrets script to setup your secrets file: `~/dotfiles/scripts/secrets.sh`

MacOS:

1. Setup your proxy (if you are in GWF)
2. Install homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
3. Clone this repository to home directory: `git clone https://github.com/fioncat/dotfiles.git ~/dotfiles`
4. Export homebrew bin path: `export PATH="/opt/homebrew/bin:$PATH"`
5. Run setup script: `~/dotfiles/scripts/setup.sh`
6. Run secrets script: `~/dotfiles/scripts/secrets.sh`

## TIPs

> [!TIP]
> If you have a dual-boot system (Windows+Linux), the time might be out of sync between the two systems. In this case, you need to execute the following command in Linux:
>
> ```bash
> sudo timedatectl set-local-rtc 1
> ```

> [!TIP]
> In some countries, accessing GitHub via SSH might be problematic, and by default, the SSH protocol doesn't use the global proxy. We need to add the following configuration to ~/.ssh/config to make GitHub's SSH protocol use HTTPS:
>
> ```ssh
> Host github.com
>     Hostname ssh.github.com
>     Port 443
>     User git
> ```

> [!TIP]
> The `hyprpaper` and `hyprlock` cannot read `jpeg` image. You can use the following command to convert `jpeg` image to `png`:
>
> ```bash
> ~/dotfiles/scripts/convert-png.py ~/Pictures/wallpaper.jpg
> ```
>
> This will generate `~/Pictures/wallpaper.png` file.

## Docker

If you are not on Arch Linux but want to experience this dotfiles, you can use Docker to achieve this:

```bash
DOCKER_CMD="sudo docker" make
docker run -it fioncat/dev:archlinux
```

Note that this Docker image is quite large, and I have not pushed it to DockerHub, so this method is only recommended for temporary experience and debugging. After you are done using it, it is advisable to delete this image.
