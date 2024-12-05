ks() {
  local config_dir hist_dir edit

  config_dir="$KS_CONFIG_DIR"
  if [[ -z "$config_dir" ]]; then
    config_dir="$HOME/.kube/config"
  fi

  hist_dir="$KS_HIST_DIR"
  if [[ -z "$hist_dir" ]]; then
    hist_dir="$HOME/.kube/.history"
  fi

  edit="$KS_EDITOR"
  if [[ -z "$edit" ]]; then
    edit="$EDITOR"
    if [[ -z "$edit" ]]; then
      edit="vim"
    fi
  fi

  mkdir -p "$config_dir"
  if [[ $? -ne 0 ]]; then
    echo "ks: failed to create config directory '$config_dir'"
    return 1
  fi

  mkdir -p "$hist_dir"
  if [[ $? -ne 0 ]]; then
    echo "ks: failed to create history directory '$hist_dir'"
    return 1
  fi

  local configs=()
  while IFS= read -r -d $'\0' file; do
    configs+=("$(basename "$file")")
  done < <(find "$config_dir" -type f,l -print0)

  local current_config="$KS_CONFIG"

  local last_use_config
  local config_hist_file="$hist_dir/config"
  if [[ -f "$config_hist_file" ]]; then
    while IFS= read -r line; do
      if [[ "$line" != "$current_config" ]]; then
        last_use_config="$line"
      fi
    done < <(tac "$config_hist_file")
    if [[ $? -ne 0 ]]; then
      echo "ks: failed to read config history file '$config_hist_file'"
      return 1
    fi
  fi

  local action="$1"
  case "$action" in
    use|''|'-')
      local config="$2"
      if [[ "$action" == "-" ]]; then
        config="-"
      fi
      if [[ -z "$config" ]]; then
        config=$(_select_array_with_fzf "${configs[@]}")
        if [[ -z "$config" ]]; then
          return 1
        fi
      fi
      if [[ "$config" == "-" ]]; then
        config="$last_use_config"
        if [[ -z "$config" ]]; then
          echo "ks: no last use config"
          return 1
        fi
      fi

      local config_path="$config_dir/$config"
      if [[ ! -f "$config_path" ]]; then
        _ks_confirm "config '$config' not found, do you want to create it?"
        if [[ $? -ne 0 ]]; then
          return 1
        fi
        $edit "$config_path"
        if [[ $? -ne 0 ]]; then
          echo "ks: failed to create config '$config'"
          return 1
        fi
      fi

      echo "Use config '$config'"
      echo "$config" >> "$config_hist_file"
      export KUBECONFIG="$config_path"
      export KS_CONFIG="$config"
      export KS_NS=""
      alias k='kubectl'
      ;;

    edit)
      local config="$2"
      if [[ -z "$config" ]]; then
        config=$(_select_array_with_fzf "${configs[@]}")
        if [[ -z "$config" ]]; then
          return 1
        fi
      fi

      local config_path="$config_dir/$config"
      $edit "$config_path"
      if [[ $? -ne 0 ]]; then
        echo "ks: failed to edit config '$config'"
        return 1
      fi
      ;;

    ns)
      local ns="$2"
      if [[ -z "$ns" ]]; then
        local items=($(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'))
        if [[ $? -ne 0 ]]; then
          echo "ks: failed to list namespaces"
          return 1
        fi

        ns=$(_select_array_with_fzf "${items[@]}")
        if [[ $? -ne 0 ]]; then
          return 1
        fi
      fi
      if [[ -z "$current_config" ]]; then
        echo "ks: no current config"
        return 1
      fi

      export KS_NS="$ns"
      alias k="kubectl -n=$ns"
      ;;

    delete|del|remove|rm)
      local config="$2"

      if [[ "$config" == "-a" ]]; then
        _ks_confirm "do you want to delete all configs?"
        if [[ $? -ne 0 ]]; then
          return 1
        fi
        rm -rf "$config_dir"
        if [[ $? -ne 0 ]]; then
          echo "ks: failed to delete all configs"
          return 1
        fi

        export KUBECONFIG=""
        export KS_CONFIG=""
        export KS_NS=""
        alias k='kubectl'
        return 0
      fi

      if [[ -z "$config" ]]; then
        config=$(_select_array_with_fzf "${configs[@]}")
        if [[ -z "$config" ]]; then
          return 1
        fi
      fi

      local config_path="$config_dir/$config"
      rm -f "$config_path"
      if [[ $? -ne 0 ]]; then
        echo "ks: failed to delete config '$config'"
        return 1
      fi

      if [[ "$config" == "$current_config" ]]; then
        export KUBECONFIG=""
        export KS_CONFIG=""
        export KS_NS=""
        alias k='kubectl'
      fi
      ;;

    'uc')
      export KUBECONFIG=""
      export KS_CONFIG=""
      export KS_NS=""
      alias k='kubectl'
      ;;

    'un')
      export KS_NS=""
      alias k='kubectl'
      ;;

    *)
      echo "ks: unknown action '$action'"
      return 1
      ;;
  esac
}

_select_array_with_fzf() {
  local input_array=("$@")
  local result
  result=$(printf "%s\n" "${input_array[@]}" | fzf --multi)
  echo "$result"
}

_ks_confirm() {
  echo -n "$1 (y/n) "
	read
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		return 0
	fi
  return 1
}
