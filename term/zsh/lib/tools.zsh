syncpkg() {
  if [[ $EUID -eq 0 ]]; then
    echo "Error: syncpkg should not be run as root"
    return 1
  fi
  python3 ~/dotfiles/scripts/syncpkg.py
}

clash() {
  if [[ "$1" == "on" ]]; then
    # Check if proxy port is accessible
    if ! nc -z 127.0.0.1 7890; then
      echo "Error: Clash proxy port 7890 is not accessible"
      return 1
    fi
    export https_proxy=http://127.0.0.1:7890
    export http_proxy=http://127.0.0.1:7890
    export all_proxy=socks5://127.0.0.1:7890
    echo "Proxy enabled"
  elif [[ "$1" == "off" ]]; then
    unset https_proxy
    unset http_proxy
    unset all_proxy
    echo "Proxy disabled"
  else
    echo "Usage: clash [on|off]"
  fi
}

clear_docker() {
  sudo docker rm -vf $(docker ps -aq)
  sudo docker rmi -f $(docker images -aq)
}

zsh_stats () {
  fc -l 1 | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

updpkg() {
  ~/dotfiles/scripts/updpkg.sh "$@"
}

command_not_found_handler() {
  local command="$1"
  local os_type="$(uname)"
  local output

  echo "Command '$command' not found"
  if [[ "$os_type" == "Linux" ]]; then
    command_not_found_archlinux "$command"
  elif [[ "$os_type" == "Darwin" ]]; then
    command_not_found_macos "$command"
  fi
  return 127
}

command_not_found_archlinux() {
  if ! command -v yay &> /dev/null; then
    return
  fi

  local command="$1"
  local output

  echo "Seaching packages..."
  output=$(yay -F --color always "usr/bin/$command" 2> /dev/null | sed "s/usr\/bin\/$command is owned by /  /g")
  if [[ -n "$output" ]]; then
    echo
    echo "Found packages:"
    echo "$output"
    echo
    echo "HINT: you can use 'yay -S <package>' to install one of them"
  else
    echo "Cannot find package contains this command"
    echo
    echo "HINT: You can try to search this in AUR: https://aur.archlinux.org/packages?K=${command}"
  fi
}

command_not_found_macos() {
  if ! command -v gh &> /dev/null; then
    return
  fi

  local command="$1"
  local output

  echo "Searching packages from homebrew-core"
  output=$(gh search code "$command path:Formula" --repo homebrew/homebrew-core --json path --jq '.[].path | sub("Formula/"; "") | sub(".rb$"; "") | split("/")[-1]')
  if [[ -n "$output" ]]; then
    echo
    echo "Found homebrew packages (contains this keyword):"
    echo "$output"
    echo
    echo "HINT: you can use 'brew install <package>' to install one of them"
  else
    echo "Cannot find package contains this keyword"
  fi
}

start-csyncd() {
  echo -n "" | pbcopy
  killall csyncd > /dev/null 2>&1
  sleep 1
  nohup csyncd > /tmp/csyncd.log 2>&1 &
}
