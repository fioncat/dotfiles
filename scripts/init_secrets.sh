#!/bin/bash

set -ex

roxide secret dotfiles/term/zsh/secrets -f .secrets
ssh-keygen

cd ~/dotfiles
roxide attach github fioncat/dotfiles

cd ~/.config/nvim
roxide attach github fioncat/spacenvim

cd $HOME
