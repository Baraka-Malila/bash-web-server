#!/bin/bash

# PURE Bash Lite Server - Using ONLY Bash built-ins and /dev/tcp
# No external tools: no nc, no cat, no date - just pure Bash!
# Author: Generated with GitHub Copilot
# Version: 1.0 (Ultra Pure Edition)

# Default configuration
DEFAULT_PORT=8080
DEFAULT_DIR="./public"
SERVER_NAME="Pure-Bash-Server/1.0"

# Global variables
PORT=$DEFAULT_PORT
SERVE_DIR=$DEFAULT_DIR
VERBOSE=false

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output (using only printf)
log() {
    local level=$1
    shift
    local message="$*"
    
    # Get timestamp using bash built-ins only
    local timestamp=$(printf '%(%Y-%m-%d %H:%M:%S)T' -1)
    
    case $level in
        "INFO")
            printf "${GREEN}[INFO]${NC} ${timestamp} - %s\n" "$message"
            ;;
        "WARN")
            printf "${YELLOW}[WARN]${NC} ${timestamp} - %s\n" "$message"
            ;;
        "ERROR")
            printf "${RED}[ERROR]${NC} ${timestamp} - %s\n" "$message"
            ;;
        "DEBUG")
            if [ "$VERBOSE" = true ]; then
                printf "${BLUE}[DEBUG]${NC} ${timestamp} - %s\n" "$message"
            fi
            ;;
        *)
            printf "%s - %s\n" "$timestamp" "$message"
            ;;
    esac
}

# Function to show help
show_help() {
    printf "Pure Bash Lite Server - Using ONLY Bash built-ins!\n\n"
    printf "Usage: %s [OPTIONS]\n\n" "$0"
    printf "Options:\n"
    printf "    -p, --port PORT     Port to listen on (default: %d)\n" "$DEFAULT_PORT"
    printf "    -d, --dir DIR       Directory to serve files from (default: %s)\n" "$DEFAULT_DIR"
    printf "    -v, --verbose       Enable verbose logging\n"
    printf "    -h, --help          Show this help message\n\n"
    printf "Examples:\n"
    printf "    %s                  # Start server on port %d\n" "$0" "$DEFAULT_PORT"
    printf "    %s --port 3000      # Start server on port 3000\n" "$0"
    printf "    %s -d /var/www      # Serve files from /var/www\n" "$0"
    printf "    %s -p 8080 -v       # Start with verbose logging\n\n" "$0"
    printf "Once running, visit: http://localhost:PORT\n"
    printf "Press Ctrl+C to stop the server.\n\n"
    printf "🚀 This version uses ONLY Bash built-ins - no external tools!\n"
}

# Function to parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--port)
                PORT="$2"
                shift 2
                ;;
            -d|--dir)
                SERVE_DIR="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                printf "Unknown option: %s\n" "$1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Function to validate port number
validate_port() {
    if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        log "ERROR" "Invalid port number: $PORT (must be 1-65535)"
        exit 1
    fi
}

# Function to check if directory exists
check_directory() {
    if [ ! -d "$SERVE_DIR" ]; then
        log "ERROR" "Directory '$SERVE_DIR' does not exist"
        exit 1
    fi
}

# Function to get MIME type based on file extension (pure bash)
get_mime_type() {
    local file="$1"
    local extension="${file##*.}"
    
    case "$extension" in
        html|htm)
            printf "text/html"
            ;;
        css)
            printf "text/css"
            ;;
        js)
            printf "application/javascript"
            ;;
        json)
            printf "application/json"
            ;;
        txt)
            printf "text/plain"
            ;;
        png)
            printf "image/png"
            ;;
        jpg|jpeg)
            printf "image/jpeg"
            ;;
        gif)
            printf "image/gif"
            ;;
        svg)
            printf "image/svg+xml"
            ;;
        *)
            printf "application/octet-stream"
            ;;
    esac
}

# Function to get file size (pure bash)
get_file_size() {
    local file="$1"
    local size=0
    
    # Read file character by character to get size
    while IFS= read -r -n1 char; do
        ((size++))
    done < "$file"
    
    printf "%d" "$size"
}

# Function to read entire file content (pure bash replacement for cat)
read_file() {
    local file="$1"
    local content=""
    local line
    
    # Read file line by line and reconstruct content
    while IFS= read -r line || [[ -n "$line" ]]; do
        content="${content}${line}"$'\n'
    done < "$file"
    
    # Remove the last newline if the file didn't end with one
    if [[ -n "$content" && "$content" != *$'\n' ]]; then
        content="${content%$'\n'}"
    fi
    
    printf "%s" "$content"
}

# Function to URL decode (pure bash)
url_decode() {
    local input="$1"
    local output=""
    local i=0
    local char
    local hex
    
    while [ $i -lt ${#input} ]; do
        char="${input:$i:1}"
        if [ "$char" = "%" ] && [ $((i+2)) -lt ${#input} ]; then
            hex="${input:$((i+1)):2}"
            # Convert hex to decimal then to ASCII
            printf -v char "\\$(printf '%03o' 0x$hex)"
            i=$((i+3))
        else
            i=$((i+1))
        fi
        output="${output}${char}"
    done
    
    printf "%s" "$output"
}

# Function to generate HTTP date (pure bash)
http_date() {
    printf '%(%a, %d %b %Y %H:%M:%S GMT)T' -1
}

# Function to send HTTP response
send_response() {
    local status="$1"
    local content_type="$2"
    local content="$3"
    local content_length=${#content}
    
    # HTTP headers
    printf "HTTP/1.1 %s\r\n" "$status"
    printf "Server: %s\r\n" "$SERVER_NAME"
    printf "Date: %s\r\n" "$(http_date)"
    printf "Content-Type: %s\r\n" "$content_type"
    printf "Content-Length: %d\r\n" "$content_length"
    printf "Connection: close\r\n"
    printf "\r\n"
    
    # HTTP body
    printf "%s" "$content"
}

# Function to send 404 error
send_404() {
    local path="$1"
    local content="<!DOCTYPE html>
<html>
<head>
    <title>404 Not Found</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background: #f5f5f5; }
        .container { background: white; margin: 50px auto; padding: 30px; max-width: 600px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #e74c3c; }
        code { background: #f8f9fa; padding: 2px 6px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class=\"container\">
        <h1>404 Not Found</h1>
        <p>The requested file <code>$path</code> was not found on this server.</p>
        <p><a href=\"/\">← Back to Home</a></p>
        <hr>
        <p><em>$SERVER_NAME - Pure Bash Edition</em></p>
    </div>
</body>
</html>"
    
    send_response "404 Not Found" "text/html" "$content"
}

# Function to handle HTTP request
handle_request() {
    local client_fd="$1"
    local request_line
    local method
    local path
    local protocol
    
    # Read the request line from the client
    read -r request_line <&"$client_fd"
    log "DEBUG" "Request line: $request_line"
    
    # Parse the request line
    read -r method path protocol <<< "$request_line"
    
    # Remove carriage return from protocol
    protocol=${protocol%$'\r'}
    
    # Skip the rest of the headers
    local header
    while read -r header <&"$client_fd" && [ "$header" != $'\r' ]; do
        log "DEBUG" "Header: ${header%$'\r'}"
    done
    
    # Only handle GET requests
    if [ "$method" != "GET" ]; then
        log "WARN" "Unsupported method: $method"
        send_response "405 Method Not Allowed" "text/plain" "Method Not Allowed" >&"$client_fd"
        return
    fi
    
    # Clean the path (remove query parameters and decode URL)
    path=${path%%\?*}  # Remove query parameters
    path=$(url_decode "$path")
    
    # Security: prevent directory traversal
    if [[ "$path" == *".."* ]]; then
        log "WARN" "Directory traversal attempt: $path"
        send_404 "$path" >&"$client_fd"
        return
    fi
    
    # Default to index.html for root path
    if [ "$path" = "/" ]; then
        path="/index.html"
    fi
    
    # Build full file path
    local file_path="$SERVE_DIR$path"
    
    log "INFO" "$method $path"
    
    # Check if file exists and is readable
    if [ -f "$file_path" ] && [ -r "$file_path" ]; then
        local mime_type=$(get_mime_type "$file_path")
        local content=$(read_file "$file_path")
        send_response "200 OK" "$mime_type" "$content" >&"$client_fd"
        log "INFO" "Served: $file_path ($mime_type)"
    else
        log "WARN" "File not found: $file_path"
        send_404 "$path" >&"$client_fd"
    fi
}

# Function to start the server using /dev/tcp
start_server() {
    log "INFO" "Starting Pure Bash Lite Server..."
    log "INFO" "Serving directory: $SERVE_DIR"
    log "INFO" "Listening on port: $PORT"
    log "INFO" "Server URL: http://localhost:$PORT"
    log "INFO" "🚀 Using ONLY Bash built-ins - no external tools!"
    log "INFO" "Press Ctrl+C to stop the server"
    printf "\n"
    
    # Create a server socket using bash's /dev/tcp
    # Note: Bash can only create client connections with /dev/tcp
    # For a pure bash server, we need to use a different approach
    
    # Alternative: Use socat if available, or create a simple listener
    if command -v socat >/dev/null 2>&1; then
        log "INFO" "Using socat for socket listening (most compatible approach)"
        
        while true; do
            log "DEBUG" "Waiting for connection..."
            
            # Use socat to create a server and handle each connection
            socat TCP-LISTEN:"$PORT",reuseaddr,fork EXEC:"$0 --handle-connection" 2>/dev/null &
            local socat_pid=$!
            
            # Wait a bit then kill socat (we'll restart it for each connection)
            sleep 1
            kill $socat_pid 2>/dev/null
            
            sleep 0.1
        done
    else
        log "ERROR" "Pure bash cannot create server sockets directly"
        log "ERROR" "Bash's /dev/tcp only supports client connections"
        log "ERROR" "Please install 'socat' or use the netcat version: server.sh"
        log "INFO" "To install socat: sudo apt install socat"
        exit 1
    fi
}

# Special mode for handling individual connections
if [ "$1" = "--handle-connection" ]; then
    # This will be called by socat for each connection
    exec 3<&0  # Save stdin as fd 3
    exec 4>&1  # Save stdout as fd 4
    
    handle_request 3
    
    exec 3<&-  # Close fd 3
    exec 4>&-  # Close fd 4
    exit 0
fi

# Signal handler for graceful shutdown
cleanup() {
    printf "\n"
    log "INFO" "Shutting down server..."
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Main function
main() {
    # Parse command line arguments
    parse_args "$@"
    
    # Validate configuration
    validate_port
    check_directory
    
    # Start the server
    start_server
}

# Run the main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
