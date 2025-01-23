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
    roxide secret $HOME/.secrets -f dotfiles/term/zsh/secrets
    ;;
  "load")
    if [[ -f $HOME/.secrets ]]; then
      echo "secrets file already exists, skip"
      exit 0
    fi
    roxide secret dotfiles/term/zsh/secrets -f $HOME/.secrets
    ;;
  *)
    echo "Usage: $0 [save|load]"
    exit 1
    ;;
esac
