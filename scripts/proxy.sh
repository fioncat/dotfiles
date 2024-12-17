#!/bin/bash

set -eu

os_type=$(uname -s)
if [[ "$os_type" != "Linux" ]]; then
  echo "Unsupported OS: $os_type"
  exit 1
fi

if [[ ! -f /etc/arch-release ]]; then
  echo "Not an Arch Linux distribution"
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "Running as root is forbidden"
  exit 1
fi

pacman="sudo pacman --noconfirm"

$pacman -S dae daed

sudo systemctl enable --now daed

echo "Congratulations! The daed has already been installed."
echo " * Please open this in your browser: http://localhost:2023"
