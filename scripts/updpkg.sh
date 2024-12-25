#!/bin/bash

# Check if running on Arch Linux
if [ ! -f "/etc/arch-release" ]; then
  echo "Error: This script can only be run on Arch Linux"
  exit 1
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "Error: This script should not be run as root"
  exit 1
fi

# Check if help is needed
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo "Usage: updpkg <pkg_name> [version]"
  echo
  echo "Arguments:"
  echo "  pkg_name    Package name (required)"
  echo "  version     Version number (optional)"
  exit 0
fi

# Check required argument
if [ -z "$1" ]; then
  echo "Error: Missing required package name argument"
  echo "Use 'updpkg --help' to see usage"
  exit 1
fi

# Set variables
pkg_name="$1"
version="$2"

set -eu

if [ -z "$version" ]; then
  # Get latest version from GitHub API
  echo "Get the latest version from GitHub API"
  version=$(gh release view -R "fioncat/${pkg_name}" --json tagName -q '.tagName' | sed -E 's/^v?//')
  if [ -z "$version" ]; then
    echo "Error: Failed to get latest version from GitHub"
    exit 1
  fi
fi

# Set AUR package name
aur_name="$pkg_name"
if [ "$pkg_name" = "csync" ]; then
  aur_name="csync-fioncat"
fi

echo "Begin to update aur package. repo_name: $pkg_name, aur_name: $aur_name, version: $version"

aur_path="/tmp/${aur_name}_${version}"
if [ -e "$aur_path" ]; then
  rm -rf "$aur_path"
fi

echo "Cloning package from AUR..."
git clone -c init.defaultBranch=master ssh://aur@aur.archlinux.org/${aur_name}.git "$aur_path"
cd "$aur_path"

# Read current version from PKGBUILD
current_version=$(grep -E '^pkgver=' PKGBUILD | cut -d'=' -f2)
if [ -z "$current_version" ]; then
  echo "Error: Failed to get current version from PKGBUILD"
  exit 1
fi

echo "Current version is: $current_version"

if [ "$current_version" = "$version" ]; then
  echo "Already up-to-date"
  rm -rf "$aur_path"
  exit 0
fi

# Update version in PKGBUILD
echo "Updating version in PKGBUILD..."
sed -i "s/^pkgver=.*/pkgver=${version}/" PKGBUILD

# Update package checksums
echo "Updating package checksums..."
updpkgsums

# Update .SRCINFO
echo "Updating .SRCINFO..."
makepkg --printsrcinfo > .SRCINFO

# Commit and push changes
echo "Config git user and email..."
git config user.name "fioncat"
git config user.email "lazycat7706@gmail.com"

echo "Commit and push changes..."
git add PKGBUILD .SRCINFO
git commit -m "update to ${version}"
git push

# Clean up
echo "Clean up..."
rm -rf "$aur_path"

echo "Done, updated $pkg_name to version: $version"
echo "See: https://aur.archlinux.org/packages/${aur_name}"
