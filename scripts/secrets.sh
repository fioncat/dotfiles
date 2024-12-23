#!/bin/bash

set -eu

if ! command -v roxide &> /dev/null; then
  echo "roxide is not installed, please install it first."
  exit 1
fi

if [[ -f $HOME/.secrets ]]; then
  echo "secrets file already exists, skip"
  exit 0
fi

roxide secret dotfiles/term/zsh/secrets -f $HOME/.secrets
