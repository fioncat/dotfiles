#!/bin/bash

if [[ -f $HOME/.zshrc ]]; then
	cp -f $HOME/.zshrc ./zshrc-macos.zsh
fi

if [[ -f $HOME/.tmux.conf ]]; then
	cp -f $HOME/.tmux.conf ./tmux.conf
fi

if [[ -f $HOME/.tmux.conf.local ]]; then
	cp -f $HOME/.tmux.conf.local ./tmux.conf.local
fi
