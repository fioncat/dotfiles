#!/bin/bash

set -eu

# Parse command line arguments
SKIP_SYSTEM=false
SKIP_RUST=false
SKIP_NVIM=false
SKIP_ROXIDE=false

while [[ $# -gt 0 ]]; do
	case $1 in
	--skip-system)
		SKIP_SYSTEM=true
		shift
		;;
	--skip-rust)
		SKIP_RUST=true
		shift
		;;
	--skip-nvim)
		SKIP_NVIM=true
		shift
		;;
	--skip-roxide)
		SKIP_ROXIDE=true
		shift
		;;
	-h | --help)
		echo "Usage: $0 [options]"
		echo "Options:"
		echo "  --skip-system  Skip system update"
		echo "  --skip-rust    Skip rust update"
		echo "  --skip-nvim    Skip neovim config update"
		echo "  --skip-roxide  Skip roxide sync"
		echo "  -h, --help     Show this help message"
		exit 0
		;;
	*)
		echo "Unknown option: $1"
		echo "Use -h or --help for usage information"
		exit 1
		;;
	esac
done

MARK_DIR="$HOME/.local/share"
mkdir -p "$MARK_DIR"

MARK_FILE="$MARK_DIR/rolling"

TODAY=$(date +%Y-%m-%d)

if [ -f "$MARK_FILE" ] && [ "$(cat "$MARK_FILE")" == "$TODAY" ]; then
	exit 0
fi

if ! command -v flock &>/dev/null; then
	# If flock not found, it means we are on macOS, use brew to install it
	brew install flock
fi

LOCK_FILE="/tmp/rolling.lock"
exec 299>"$LOCK_FILE"
flock 299

# After acquiring the lock, check again to avoid another process has already done the update
if [ -f "$MARK_FILE" ] && [ "$(cat "$MARK_FILE")" == "$TODAY" ]; then
	exit 0
fi

CLASH_FLAG_FILE="$HOME/dotfiles/rolling_clash"
if [ -f "$CLASH_FLAG_FILE" ]; then
	clash on
fi

if [ "$SKIP_SYSTEM" = false ]; then
	echo "Rolling update your system"

	OS_TYPE=$(uname -s)
	case "$OS_TYPE" in
	Darwin)
		brew update && brew upgrade --force
		brew cleanup
		;;
	Linux)
		# yay -Fy downloads database files to local so that we can search packages
		yay -Fy && yay --noconfirm
		yay -Sc --noconfirm
		;;
	*)
		echo "Unsupported OS: $OS_TYPE"
		exit 1
		;;
	esac
fi

if [ "$SKIP_ROXIDE" = false ]; then
	echo "Updating all git repositories"
	ROXIDE_NO_CONFIRM="true" ROXIDE_WRAP="true" roxide sync -r
else
	echo "Skipping roxide sync"
fi

if [ "$SKIP_RUST" = false ]; then
	echo "Updating rust"
	rustup update
else
	echo "Skipping rust update"
fi

echo "Rolling done"
echo "$TODAY" >"$MARK_FILE"
