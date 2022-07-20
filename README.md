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

Install dotfiles:

```shell
mv ~/.zshrc ~/.zshrc.back
curl -fsSL https://raw.githubusercontent.com/fioncat/dotfiles/master/zshrc-macos.zsh > ~/.zshrc
```

## tmux

Install tmux:

```shell
brew install tmux
```

Install dotfiles:

```shell
mv ~/.tmux.conf ~/.tmux.conf.back
mv ~/.tmux.conf.local ~/.tmux.conf.local.back
curl -fsSL https://raw.githubusercontent.com/fioncat/dotfiles/master/tmux.conf > ~/.tmux.conf
curl -fsSL https://raw.githubusercontent.com/fioncat/dotfiles/master/tmux.conf.local > ~/.tmux.conf.local
```
