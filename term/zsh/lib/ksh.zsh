ksh() {
  local namespace image shell

  namespace="$KSH_NAMESPACE"
  if [[ -z "$namespace" ]]; then
    namespace="kube-system"
  fi

  image="$KSH_IMAGE"
  if [[ -z "$image" ]]; then
    image="uhub.service.ucloud.cn/library/alpine:latest"
  fi

  shell="$KSH_SHELL"
  if [[ -z "$shell" ]]; then
    shell="bash"
  fi

  local action node node_path cp_source cp_target source_remote target_remote
  action="$1"
  if [[ -z "$action" ]]; then
    echo "Usage: ksh (login|cp) (<node>|<source> <target>)"
    return 1
  fi

  case "$action" in
    login)
      node=$2
      if [[ -z "$node" ]]; then
        echo "login: node name is required"
        return 1
      fi
      ;;
    cp)
      cp_source=$2
      cp_target=$3
      if [[ -z "$cp_source" ]]; then
        echo "cp: source is required"
        return 1
      fi
      if [[ -z "$cp_target" ]]; then
        echo "cp: target is required"
        return 1
      fi

      if [[ "$cp_source" =~ ^(.+):(.+)$ ]]; then
        node="${match[1]}"
        node_path="${match[2]}"
        source_remote="true"
      elif [[ "$cp_target" =~ ^(.+):(.+)$ ]]; then
        node="${match[1]}"
        node_path="${match[2]}"
        target_remote="true"
      else
        echo "cp: require an arg to be '{node}:/path'"
        return 1
      fi
      ;;
    *)
      echo "ksh: unknown action '$action'"
      return 1
      ;;
  esac

  local pod_name="nodeshell-$(echo $node | tr '.' '-')-$(head /dev/urandom | tr -dc a-z0-9 | head -c 5)"

  if [[ $source_remote == "true" ]]; then
    cp_source="$pod_name:$node_path"
  elif [[ $target_remote == "true" ]]; then
    cp_target="$pod_name:$node_path"
  fi

  local yaml="$(
cat <<EOT
apiVersion: v1
kind: Pod
metadata:
  name: ${pod_name}
  namespace: ${namespace}
  labels:
    app: nodeshell
spec:
  nodeName: ${node}
  hostNetwork: true
  hostPID: true
  hostIPC: true
  containers:
  - name: nodeshell
    image: ${image}
    command: ["nsenter"]
    args: ["-t", "1", "-m", "-u", "-i", "-n", "sleep", "infinity"]
    workingDir: "/root"
    securityContext:
      privileged: true
EOT
  )"

  echo "Spawning shell on '$node'"

  kubectl get node $node > /dev/null
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  echo "$yaml" | kubectl apply -f - > /dev/null
  if [[ $? -ne 0 ]]; then
    echo "Create nodeshell pod failed"
    return 1
  fi

  # Wait pod to become running
  local timeout=20
  local interval=2
  local elapsed=0
  local pod_status

  while [[ $elapsed -lt $timeout ]]; do
    pod_status=$(kubectl get pod $pod_name -n $namespace -o jsonpath='{.status.phase}')
    if [[ $? -ne 0 ]]; then
        echo "Get pod '$namespace/$pod_name' failed"
        return 1
    fi

    if [[ $pod_status == "Running" ]]; then
        break
    fi

    sleep $interval
    elapsed=$((elapsed + interval))
  done

  if [[ $pod_status != "Running" ]]; then
    echo "Pod '$namespace/$pod_name' not running after $timeout seconds, its status is '$status'"
    return 1
  fi

  case "$action" in
    login)
      echo "Login to '$node' with '$shell'"
      kubectl -n $namespace exec -it $pod_name -- $shell
      ;;

    cp)
      echo "Copying from '$cp_source' to '$cp_target'"
      kubectl -n $namespace cp $cp_source $cp_target
      ;;
  esac

  local shell_failed
  if [[ $? -ne 0 ]]; then
    shell_failed="true"
  fi

  echo "Deleting shell on '$node'"
  kubectl delete pod $pod_name -n $namespace > /dev/null
  if [[ $? -ne 0 ]]; then
    echo "Delete pod '$namespace/$pod_name' failed"
  fi

  if [[ $shell_failed == "true" ]]; then
    echo "ksh failed"
    return 1
  fi
}

_ksh_completion() {
  local curcontext="$curcontext" state line
  typeset -A opt_args

  _arguments -C \
    '1: :->subcmds' \
    '2: :->args' \
    '*:: :->files'

  case $state in
    subcmds)
      _values 'subcommands' 'login' 'cp'
      ;;
    args)
      case $words[2] in
        login)
          local nodes
          nodes=(${(f)"$(kubectl get nodes --no-headers)"})

          local display_nodes
          for node in $nodes; do
            local name=$(echo $node | awk '{print $1}')
            display_nodes+=("$name:$node")
          done

          _describe 'nodes' display_nodes
          ;;
        cp)
          _files
          ;;
      esac
      ;;
    files)
      _files
      ;;
  esac
}

compdef _ksh_completion ksh
