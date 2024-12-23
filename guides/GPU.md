# GPU

References:

- [archlinux 显卡驱动](https://arch.icekylin.online/guide/rookie/graphic-driver.html).

## Intel

```bash
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel
```

## NVIDIA

```bash
sudo pacman -S nvidia-open nvidia-settings lib32-nvidia-utils
```

## AMD

```bash
sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
```
