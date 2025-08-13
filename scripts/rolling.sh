#!/bin/bash

set -eu

# Parse command line arguments
SKIP_RUST=false
SKIP_NVIM=false
SKIP_ROXIDE=false

while [[ $# -gt 0 ]]; do
	case $1 in
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

LOCK_FILE="/tmp/rolling.lock"
exec 299>"$LOCK_FILE"
flock 299

# After acquiring the lock, check again to avoid another process has already done the update
if [ -f "$MARK_FILE" ] && [ "$(cat "$MARK_FILE")" == "$TODAY" ]; then
	exit 0
fi

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

if [ "$SKIP_ROXIDE" = false ]; then
	echo "Updating all git repositories"
	ROXIDE_NOCONFIRM="true" roxide sync -r
else
	echo "Skipping roxide sync"
fi

if [ "$SKIP_RUST" = false ]; then
	echo "Updating rust"
	rustup update
else
	echo "Skipping rust update"
fi

if [ "$SKIP_NVIM" = false ] && [ -d "$HOME/.config/nvim" ]; then
	echo "Updating neovim config"
	cd $HOME/.config/nvim
	git checkout custom

	if ! git remote | grep -q "^upstream$"; then
		git remote add upstream https://github.com/ayamir/nvimdots.git
	fi
	git fetch upstream
	git rebase upstream/main
	git push -f origin main

	nvim --headless "+Lazy! update" +qa
	git reset --hard origin/custom
elif [ "$SKIP_NVIM" = true ]; then
	echo "Skipping neovim config update"
fi

echo "Rolling done"
echo "$TODAY" >"$MARK_FILE"
