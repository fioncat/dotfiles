export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

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

source $ZSH/oh-my-zsh.sh

bindkey '^E' end-of-line

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/Library/Python/3.8/bin
export PATH=$PATH:/opt/homebrew/bin

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

# brew install kubectl
alias k="kubectl"

alias cg="cargo"

# brew install tmux
alias tm='tmux'

if command -v nvim &> /dev/null; then
	alias vim='nvim'
	alias vi='nvim'
	export EDITOR='nvim'
else
	export EDITOR='vim'
fi

# sh -c "$(curl -fsSL https://starship.rs/install.sh)"
if command -v starship &> /dev/null; then
	eval "$(starship init zsh)"
fi

function ghproxy() {
	if [ -z $1 ]; then
		git config --global http.proxy http://127.0.0.1:7890
		git config --global https.proxy https://127.0.0.1:7890
		echo "Set git proxy to 127.0.0.1:7890 success!"
		return
	fi
	git config --global --unset http.proxy
	git config --global --unset https.proxy
	echo "Unset git proxy success!"
}

# brew install fzf
if command -v fzf &> /dev/null; then
	export FZF_DEFAULT_OPTS='--height 80% --reverse --border'
fi

# zsh -c "$(curl -fsSL https://raw.githubusercontent.com/fioncat/workflow.zsh/master/install.zsh)"
if [[ -f $HOME/dev/init.zsh ]]; then
	source $HOME/dev/init.zsh
fi

