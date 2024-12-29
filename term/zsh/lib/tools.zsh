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

  echo "Command '$command' not found. Searching for package..."

  if [[ "$os_type" == "Linux" ]]; then
    output=$(yay -F --color always "usr/bin/$command" 2> /dev/null)
    if [[ -n "$output" ]]; then
      output=$(echo "$output" | sed "s/usr\/bin\/$command is owned by /  /g")
      output=$(echo "Found pacman packages:\n${output}\n\nHINT: you can use 'yay -S <package>' to install one of them")
    fi
  elif [[ "$os_type" == "Darwin" ]]; then
    output=$(brew search "$command" 2> /dev/null)
  fi

  if [[ -n "$output" ]]; then
    echo
    echo "$output"
  else
    echo "Cannot find package contains this command"
  fi

  return 127
}
