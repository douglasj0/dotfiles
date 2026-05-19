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
