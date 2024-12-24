syncpkg() {
  if [[ $EUID -eq 0 ]]; then
    echo "Error: syncpkg should not be run as root"
    return 1
  fi
  python3 ~/dotfiles/scripts/syncpkg.py
}
