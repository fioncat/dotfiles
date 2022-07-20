# dotfiles

## zshrc (macos)

Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh):

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install plugins:

```shell
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Install [starship](https://github.com/starship/starship):

```shell
curl -sS https://starship.rs/install.sh | sh
```

Install [fzf](https://github.com/junegunn/fzf):

```shell
brew install fzf
```

Install [workflow.zsh](https://github.com/fioncat/workflow.zsh):

```shell
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/fioncat/workflow.zsh/master/install.zsh)"
```

## tmux

Install tmux:

```shell
brew install tmux
```
