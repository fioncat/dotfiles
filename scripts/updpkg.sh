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
	echo
	echo "Environment variables:"
	echo "  NOAUR       If 'true', skip AUR package update"
	echo "  NOBREW      If 'true' Skip Homebrew formula update"
	echo
	echo "Available packages: roxide, otree, kubewrap, csync"
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

NOAUR="$NOAUR"
NOBREW="$NOBREW"

if [ -n "$NOAUR" ] && [ -n "$NOBREW" ]; then
	echo "Error: No package to update"
	echo "Use 'updpkg --help' to see usage"
	exit 1
fi

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

update_aur() {
	# Set AUR package name
	aur_name="$pkg_name-release"

	echo "Begin to update AUR package $pkg_name to $version"

	aur_path="/tmp/aur_${aur_name}"
	if [[ ! -e "$aur_path" ]]; then
		echo "Cloning package from AUR..."
		git clone -c init.defaultBranch=master ssh://aur@aur.archlinux.org/${aur_name}.git "$aur_path"
	fi
	cd "$aur_path"

	# Read current version from PKGBUILD
	current_version=$(grep -E '^pkgver=' PKGBUILD | cut -d'=' -f2)
	if [ -z "$current_version" ]; then
		echo "Error: Failed to get current version from PKGBUILD"
		exit 1
	fi

	echo "Current AUR version is: $current_version"
	if [ "$current_version" != "$version" ]; then
		# Update version in PKGBUILD
		echo "Updating version in PKGBUILD..."
		sed -i "s/^pkgver=.*/pkgver=${version}/" PKGBUILD

		# Update package checksums
		echo "Updating package checksums..."
		updpkgsums

		# Update .SRCINFO
		echo "Updating .SRCINFO..."
		makepkg --printsrcinfo >.SRCINFO

		# Commit and push changes
		echo "Config git user and email..."
		git config user.name "fioncat"
		git config user.email "lazycat7706@gmail.com"

		echo "Commit and push changes..."
		git add PKGBUILD .SRCINFO
		git commit -m "update to ${version}"
		git push

		echo "Done, updated AUR $pkg_name to version: $version"
	else
		echo "AUR already up-to-date"
	fi

	echo "Cleaning up..."
	cd /tmp
	rm -rf "$aur_path"
}

update_homebrew() {
	echo "Begin to update homebrew formula $pkg_name to $version"
	tap_path="/tmp/homebrew-apps"
	if [[ ! -e "$tap_path" ]]; then
		echo "Cloning homebrew-apps..."
		echo "$tap_path"
		git clone git@github.com:fioncat/homebrew-apps.git "$tap_path"
	fi
	cd "$tap_path"

	# Read current version from formula url
	formula_path="Formula/${pkg_name}.rb"
	current_version=$(grep -E '^\s*url\s*"' "$formula_path" | grep -o 'v[0-9.]*' | sed 's/v\(.*\)/\1/')
	if [ -z "$current_version" ]; then
		echo "Error: Failed to get current version from formula url"
		exit 1
	fi

	echo "Current homebrew version is: $current_version"
	if [ "$current_version" != "$version" ]; then
		# Get formula URL and download file
		url=$(grep -E '^\s*url\s*"' "$formula_path" | sed 's/.*url\s*"\(.*\)".*/\1/')
		new_url=$(echo "$url" | sed "s/v${current_version}/v${version}/")

		echo "Downloading $new_url to calculate sha256..."
		tmp_file="/tmp/${pkg_name}-${version}.tar.gz"
		curl -L -o "$tmp_file" "$new_url"

		# Calculate sha256
		new_sha256=$(sha256sum "$tmp_file" | cut -d' ' -f1)
		rm -f "$tmp_file"

		# Update formula file
		echo "Updating formula URL and sha256..."
		sed -i "s|url \".*\"|url \"${new_url}\"|" "$formula_path"
		sed -i "s|sha256 \".*\"|sha256 \"${new_sha256}\"|" "$formula_path"

		echo "Config git user and email..."
		git config user.name "fioncat"
		git config user.email "lazycat7706@gmail.com"

		# Commit and push changes
		echo "Commit and push changes..."
		git add "$formula_path"
		git commit -m "Update ${pkg_name} to ${version}"
		git push
	else
		echo "Homebrew already up-to-date"
	fi

	echo "Cleaning up..."
	cd /tmp
	rm -rf "$tap_path"
}

if [ -z "$NOAUR" ]; then
	update_aur
fi

if [ -z "$NOBREW" ]; then
	update_homebrew
fi

echo
echo "Done, references:"
if [ -z "$NOAUR" ]; then
	echo "  * AUR: https://aur.archlinux.org/packages/${aur_name}"
fi
if [ -z "$NOBREW" ]; then
	echo "  * Homebrew: https://github.com/fioncat/homebrew-apps/blob/main/Formula/${pkg_name}.rb"
fi
