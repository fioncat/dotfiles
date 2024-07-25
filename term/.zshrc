export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

export PATH=$PATH:$HOME/dev/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/bin

plugins=(
	# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	zsh-autosuggestions

	# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	zsh-syntax-highlighting

	macos
	vi-mode
	fzf
	golang
	docker
	rust
)

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6a687a"

source $ZSH/oh-my-zsh.sh

bindkey '^E' end-of-line

autoload bashcompinit
bashcompinit

export TERM=xterm-256color

alias gs="git status"
alias gl="git pull"
alias gp="git push"
alias gpf="git push -f origin"
alias gps="git push --set-upstream origin"
alias gck="git checkout"
alias gr="git restore"
alias gm="git merge"
alias gcb="git checkout -b"
alias gd="git diff"
alias ga="git add"
alias gc="git commit"

alias k="kubectl"
alias cg="cargo"
alias tm='tmux'

if command -v vim &> /dev/null; then
	alias vi=$(which vim)
fi

if command -v nvim &> /dev/null; then
	alias vim='nvim'
	export EDITOR='nvim'
else
	export EDITOR='vim'
fi

if command -v starship &> /dev/null; then
	eval "$(starship init zsh)"
fi

if command -v bat &> /dev/null; then
	export BAT_THEME="catppuccin-mocha"
fi

if command -v btm &> /dev/null; then
	alias top="btm"
fi

if command -v duf &> /dev/null; then
	alias df="duf"
fi

if command -v exa &> /dev/null; then
	alias ls="exa"
fi

if command -v dust &> /dev/null; then
	alias du="dust -b"
fi

if command -v fzf &> /dev/null; then
	export FZF_DEFAULT_OPTS=" \
--height 80% \
--reverse \
--border \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
fi

alias docker="sudo docker"

if [ -f $HOME/.secrets ]; then
	source $HOME/.secrets
fi

if [ -f $HOME/.zshrc_custom.zsh ]; then
	source $HOME/.zshrc_custom.zsh
fi

if command -v roxide &> /dev/null; then
	source <(roxide init zsh)
	alias zz="rox home"
fi

if command -v kser &> /dev/null; then
	source <(kser init zsh)
fi

if command -v google-chrome-stable &> /dev/null; then
	export BROWSER='google-chrome-stable'
fi
