mkpkg() {
  if [[ $EUID -eq 0 ]]; then
    echo "Error: mkpkg should not be run as root"
    return 1
  fi
  python3 ~/dotfiles/scripts/mkpkg.py
}
