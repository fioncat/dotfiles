print_welcome() {
  echo "\033[38;5;213m"
  echo ",--.                            ,-----.          ,--.   "
  echo "|  |    ,--,--.,-----.,--. ,--.'  .--./ ,--,--.,-'  '-. "
  echo "|  |   ' ,-.  |\`-.  /  \  '  / |  |    ' ,-.  |'-.  .-' "
  echo "|  '--.\\ '-'  | /  \`-.  \   '  '  '--'\\ '-'  |  |  |   "
  echo "\`-----' \`--\`--'\`-----'.-'  /    \`-----' \`--\`--'  \`--'   "
  echo "                      \`---'   "
  echo "\033[0m"

  # Get system information
  echo "\033[36mSystem Information:\033[0m"
  echo "  \033[35mOperating System:\033[0m $os_name"
  echo "  \033[35mHostname:\033[0m $(hostname)"
  echo "  \033[35mCurrent User:\033[0m $USER"
  echo "  \033[35mKernel Version:\033[0m $(uname -r)"
  echo "  \033[35mSystem Time:\033[0m $(date '+%Y-%m-%d %H:%M:%S')"

  if [[ $os_name == "Linux" ]]; then
    # Get Linux system information
    cpu_cores=$(nproc)
    cpu_model=$(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d':' -f2 | xargs)
    mem_total=$(free -h | awk '/^Mem:/ {print $2}')
    mem_used=$(free -h | awk '/^Mem:/ {print $3}')
    disk_info=$(df -h / | awk 'NR==2 {print $2 " total, " $3 " used (" $5 ")"}')
    uptime_info=$(uptime -p | sed 's/^up //')

    echo "  \033[35mCPU Model:\033[0m $cpu_model"
    echo "  \033[35mCPU Cores:\033[0m $cpu_cores"
    echo "  \033[35mMemory Usage:\033[0m $mem_used / $mem_total"
    echo "  \033[35mDisk Usage:\033[0m $disk_info"
    echo "  \033[35mSystem Uptime:\033[0m $uptime_info"
  elif [[ $os_name == "Darwin" ]]; then
    # Get macOS system information
    cpu_cores=$(sysctl -n hw.ncpu)
    cpu_model=$(sysctl -n machdep.cpu.brand_string)
    mem_total=$(sysctl -n hw.memsize | awk '{ printf "%.1fG\n", $1/1024/1024/1024 }')
    mem_used=$(ps -A -o rss | awk '{sum+=$1} END {printf "%.1fG\n", sum/1024/1024}')
    disk_info=$(df -h / | awk 'NR==2 {print $2 " total, " $3 " used (" $5 ")"}')
    boot_time=$(sysctl -n kern.boottime | awk -F'[{ ,}]' '{print $4}')
    current_time=$(date +%s)
    uptime_seconds=$((current_time - boot_time))
    uptime_info=$(printf '%d days %d hours %d minutes\n' $((uptime_seconds/86400)) $((uptime_seconds%86400/3600)) $((uptime_seconds%3600/60)))

    echo "  \033[35mCPU Model:\033[0m $cpu_model"
    echo "  \033[35mCPU Cores:\033[0m $cpu_cores"
    echo "  \033[35mMemory Usage:\033[0m $mem_used / $mem_total"
    echo "  \033[35mDisk Usage:\033[0m $disk_info"
    echo "  \033[35mSystem Uptime:\033[0m $uptime_info"
  fi
  echo

  if [[ $os_name == "Linux" ]]; then
    if command -v pacman &> /dev/null; then
      updates=$(pacman -Qu | wc -l)
      if [ $updates -gt 0 ]; then
        echo "\033[33mYou have $updates package(s) to update\033[0m"
      else
        echo "\033[32mGreat! Your system is up to date\033[0m"
      fi
    fi
  elif [[ $os_name == "Darwin" ]]; then
    if command -v brew &> /dev/null; then
      brew update &> /dev/null
      updates=$(brew outdated | wc -l)
      if [ $updates -gt 0 ]; then
        echo "\033[33mYou have $updates package(s) to update\033[0m"
      else
        echo "\033[32mGreat! Your system is up to date\033[0m"
      fi
    fi
  fi
}
