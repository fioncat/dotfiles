# Daily update, execute this every morning
meow() {
  os_type=$(uname -s)

  case "$os_type" in
    Darwin)
      brew upgrade
      if [[ $? -ne 0 ]]; then
        echo "brew rolling failed"
        return 1
      fi
      ;;
    Linux)
      yay --noconfirm
      if [[ $? -ne 0 ]]; then
        echo "yay rolling failed"
        return 1
      fi
      ;;
    *)
      echo "Unsupported OS: $os_type"
      return 1
      ;;
  esac

  # Sync all repos
  ROXIDE_NOCONFIRM="true" roxide sync
  if [[ $? -ne 0 ]]; then
    echo "roxide sync failed"
    return 1
  fi

  # Update editor
  nvim --headless "+Lazy! update" +qa
  if [[ $? -ne 0 ]]; then
    echo "nvim update failed"
    return 1
  fi
  git -C ~/.config/nvim add .
  git -C ~/.config/nvim commit -m "chore: update plugins version"
  git -C ~/.config/nvim push origin main

  # Update rust
  rustup update
  if [[ $? -ne 0 ]]; then
    echo "rustup update failed"
    return 1
  fi
}
