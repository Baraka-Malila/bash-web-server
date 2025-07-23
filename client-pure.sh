#!/bin/bash

# PURE BASH TCP CLIENT
# Demonstrates TCP connectivity using only /dev/tcp

tcp_request() {
    local host="${1:-localhost}"
    local port="${2:-8080}"
    local path="${3:-/}"
    
    printf "Connecting to %s:%s...\n" "$host" "$port" >&2
    
    # Open TCP connection using Bash built-in
    exec 3<>"/dev/tcp/$host/$port" || {
        printf "Connection failed!\n" >&2
        return 1
    }
    
    # Send HTTP request
    printf "GET %s HTTP/1.1\r\nHost: %s\r\nConnection: close\r\n\r\n" "$path" "$host" >&3
    
    # Read response
    local response=""
    while IFS= read -r line <&3; do
        response+="$line"$'\n'
    done
    
    # Close connection
    exec 3<&- 3>&-
    
    printf "%s" "$response"
}

# Main
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    printf "PURE BASH TCP CLIENT\n===================\n\n"
    
    if [ $# -eq 0 ]; then
        printf "Usage: %s <host> <port> [path]\n" "$0"
        printf "Example: %s localhost 8080 /\n" "$0"
        printf "Example: %s google.com 80 /\n" "$0"
        exit 1
    fi
    
    tcp_request "$@"
fi
