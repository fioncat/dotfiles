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
