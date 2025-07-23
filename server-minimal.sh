#!/bin/bash

# MINIMAL Pure Bash Web Server
# Uses only Bash built-ins + one system call to netcat for socket creation
# This is the absolute minimum needed for a working web server
# Author: Generated with GitHub Copilot

DEFAULT_PORT=8080
DEFAULT_DIR="./public"
SERVER_NAME="Minimal-Bash-Server/1.0"

PORT=$DEFAULT_PORT
SERVE_DIR=$DEFAULT_DIR

# Simple logging (no colors, minimal dependencies)
log() {
    printf "[%s] %s\n" "$(printf '%(%H:%M:%S)T' -1)" "$*" >&2
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port) PORT="$2"; shift 2 ;;
        -d|--dir) SERVE_DIR="$2"; shift 2 ;;
        -h|--help)
            printf "Minimal Bash Web Server\n"
            printf "Usage: %s [-p port] [-d directory]\n" "$0"
            exit 0
            ;;
        *) printf "Unknown option: %s\n" "$1"; exit 1 ;;
    esac
done

# Pure bash file reader (replaces cat)
read_file() {
    local content="" line
    while IFS= read -r line || [[ -n "$line" ]]; do
        content="${content}${line}"$'\n'
    done < "$1"
    printf "%s" "${content%$'\n'}"
}

# Pure bash MIME type detection
get_mime() {
    case "${1##*.}" in
        html|htm) printf "text/html" ;;
        css) printf "text/css" ;;
        js) printf "application/javascript" ;;
        *) printf "text/plain" ;;
    esac
}

# Generate HTTP response (pure bash)
http_response() {
    local path="$1"
    
    # Clean path
    path="${path%%\?*}"
    [ "$path" = "/" ] && path="/index.html"
    
    # Security: block directory traversal
    [[ "$path" == *".."* ]] && path="/index.html"
    
    local file="$SERVE_DIR$path"
    
    if [ -f "$file" ] && [ -r "$file" ]; then
        local content mime
        content=$(read_file "$file")
        mime=$(get_mime "$file")
        
        # HTTP response
        printf "HTTP/1.1 200 OK\r\n"
        printf "Server: %s\r\n" "$SERVER_NAME"
        printf "Content-Type: %s\r\n" "$mime"
        printf "Content-Length: %d\r\n" "${#content}"
        printf "Connection: close\r\n"
        printf "\r\n"
        printf "%s" "$content"
        
        log "200 $path"
    else
        # 404 response
        local not_found="<!DOCTYPE html>
<html><head><title>404 Not Found</title></head>
<body><h1>404 Not Found</h1><p>File not found: $path</p></body></html>"
        
        printf "HTTP/1.1 404 Not Found\r\n"
        printf "Server: %s\r\n" "$SERVER_NAME"
        printf "Content-Type: text/html\r\n"
        printf "Content-Length: %d\r\n" "${#not_found}"
        printf "Connection: close\r\n"
        printf "\r\n"
        printf "%s" "$not_found"
        
        log "404 $path"
    fi
}

# Main server function
start_server() {
    # Validate setup
    [ ! -d "$SERVE_DIR" ] && { log "ERROR: Directory $SERVE_DIR not found"; exit 1; }
    
    log "Starting Minimal Bash Server..."
    log "Serving: $SERVE_DIR on port $PORT"
    log "Visit: http://localhost:$PORT"
    log "Press Ctrl+C to stop"
    
    # Check if we can use the ultra-minimal approach
    if command -v nc >/dev/null 2>&1; then
        # Use netcat for socket (minimal external dependency)
        while true; do
            {
                # Read HTTP request line
                read -r request_line
                
                # Extract path from "GET /path HTTP/1.1"
                set -- $request_line
                local method="$1" path="$2"
                
                # Skip headers until empty line
                while read -r line && [ "$line" != $'\r' ]; do :; done
                
                # Generate response
                [ "$method" = "GET" ] && http_response "$path"
                
            } | nc -l -p "$PORT" -q 1
            
            sleep 0.1  # Brief pause between connections
        done
    else
        log "ERROR: netcat (nc) is required for socket operations"
        log "Pure Bash cannot create server sockets directly"
        log "Install netcat: sudo apt install netcat-openbsd"
        exit 1
    fi
}

# Signal handling
trap 'printf "\nShutting down...\n"; exit 0' INT TERM

# Start the server
start_server
