#!/bin/bash

action="$1"

set -eu

if ! command -v roxide &> /dev/null; then
  echo "roxide is not installed, please install it first."
  exit 1
fi

case $action in
  "save")
    if [[ ! -f $HOME/.secrets ]]; then
      echo "secrets file does not exist, skip"
      exit 0
    fi
    roxide secret $HOME/.secrets -f $HOME/dotfiles/term/zsh/secrets
    ;;
  "load")
    roxide secret $HOME/dotfiles/term/zsh/secrets -f $HOME/.secrets
    ;;
  "save-csync")
    roxide secret $HOME/dotfiles/apps/csync/client.toml -f $HOME/dotfiles/apps/csync/client.secret
    ;;
  "load-csync")
    roxide secret $HOME/dotfiles/apps/csync/client.secret -f $HOME/dotfiles/apps/csync/client.toml
    ;;
  *)
    echo "Usage: $0 [save|load|save-csync|load-csync]"
    exit 1
    ;;
esac
