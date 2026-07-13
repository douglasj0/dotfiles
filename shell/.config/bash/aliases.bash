# bash .bash_aliases
#
alias ll="ls -la"
alias keepalive='while true; do date >/dev/null; sleep 120; done'

# functions
tree() {
    # If no directory is provided, use the current one
    local target=${1:-.}
    find "$target" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

check_port() {
    if [ $# -eq 0 ]; then
        echo "Usage: check_port <ip> <port>"
        return 1
    fi
    local host=$1
    local port=$2
    local timeout=${3:-2} # Default to 2 seconds if not specified

    if timeout "$timeout" bash -c "true < /dev/tcp/$host/$port" 2>/dev/null; then
        echo "Connection to $host port $port [tcp] succeeded!"
        return 0
    else
        echo "Connection to $host port $port [tcp] failed."
        return 1
    fi
}

swap_usage() {
  for file in /proc/[0-9]*/status; do
    awk '
      /^Name:/   { name=$2 }
      /^VmSwap:/ { swap=$2 }
      END { if (swap+0 > 0) printf "%20s %10s kB\n", name, swap }
    ' $file 2>/dev/null
  done | sort -nrk2,2
}

swap_pid_usage() {
    for file in /proc/[0-9]*/status; do
        pid=$(basename "$(dirname "$file")")
        awk -v pid="$pid" '
            /^Name:/   { name=$2 }
            /^VmSwap:/ { swap=$2 }
            END { if (swap+0 > 0) printf "%-20s pid=%-8s swap=%10s kB\n", name, pid, swap }
        ' "$file" 2>/dev/null
    done | sort -nrk4,4
}
