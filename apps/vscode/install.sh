#!/usr/bin/env bash
#
# Install VSCode configuration files by creating symlinks from the
# default VSCode config directory to this dotfiles repository.
#
# Usage:
#   Run from the dotfiles root (~/dotfiles):
#     bash apps/vscode/install.sh
#
# What it does:
#   - Symlinks settings.json and keybindings.json into the VSCode user config dir.
#   - Skips files that are already correctly symlinked.
#   - Removes and re-links files that exist but are not symlinks to this repo.
#
# Supported platforms: Linux, macOS

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
VSCODE_DOTFILES_DIR="$DOTFILES_DIR/apps/vscode"

# Determine the VSCode user configuration directory based on OS.
case "$(uname -s)" in
    Linux*)  VSCODE_CONFIG_DIR="$HOME/.config/Code/User" ;;
    Darwin*) VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User" ;;
    *)
        echo "Error: Unsupported platform $(uname -s)"
        exit 1
        ;;
esac

# create_link creates a symlink from $2 -> $1.
# If the link already points to the correct target, it is skipped.
# If a regular file/dir exists at the link path, it is removed first.
create_link() {
    local target="$1"
    local link="$2"

    if [[ -L "$link" ]]; then
        local current_target
        current_target="$(readlink -f "$link")"
        if [[ "$current_target" == "$(readlink -f "$target")" ]]; then
            echo "  [skip] $link -> already linked correctly"
            return
        fi
        echo "  [update] $link -> removing old symlink"
        rm "$link"
    elif [[ -e "$link" ]]; then
        echo "  [replace] $link -> removing existing file"
        rm -rf "$link"
    fi

    echo "  [link] $link -> $target"
    ln -s "$target" "$link"
}

echo "Installing VSCode configuration..."
echo "  Source:  $VSCODE_DOTFILES_DIR"
echo "  Target:  $VSCODE_CONFIG_DIR"
echo

# Ensure the VSCode config directory exists.
mkdir -p "$VSCODE_CONFIG_DIR"

create_link "$VSCODE_DOTFILES_DIR/settings.json"    "$VSCODE_CONFIG_DIR/settings.json"
create_link "$VSCODE_DOTFILES_DIR/keybindings.json"  "$VSCODE_CONFIG_DIR/keybindings.json"

echo
echo "Done."
