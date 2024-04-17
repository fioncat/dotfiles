#!/bin/bash

sudo pacman -S networkmanager
systemctl enable --now NetworkManager
nmtui
