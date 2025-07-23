#!/bin/bash

# Bash Lite Server - A simple static web server in pure Bash
# Author: Generated with GitHub Copilot
# Version: 1.0

# Default configuration
DEFAULT_PORT=8080
DEFAULT_DIR="./public"
SERVER_NAME="Bash-Lite-Server/1.0"

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

# Function to print colored output
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} ${timestamp} - $message"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} ${timestamp} - $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${timestamp} - $message"
            ;;
        "DEBUG")
            if [ "$VERBOSE" = true ]; then
                echo -e "${BLUE}[DEBUG]${NC} ${timestamp} - $message"
            fi
            ;;
        *)
            echo "$timestamp - $message"
            ;;
    esac
}

# Function to show help
show_help() {
    cat << EOF
Bash Lite Server - A simple static web server in pure Bash

Usage: $0 [OPTIONS]

Options:
    -p, --port PORT     Port to listen on (default: $DEFAULT_PORT)
    -d, --dir DIR       Directory to serve files from (default: $DEFAULT_DIR)
    -v, --verbose       Enable verbose logging
    -h, --help          Show this help message

Examples:
    $0                  # Start server on port $DEFAULT_PORT
    $0 --port 3000      # Start server on port 3000
    $0 -d /var/www      # Serve files from /var/www
    $0 -p 8080 -v       # Start with verbose logging

Once running, visit: http://localhost:PORT
Press Ctrl+C to stop the server.
EOF
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
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Function to validate dependencies
check_dependencies() {
    log "DEBUG" "Checking dependencies..."
    
    # Check if nc (netcat) is available
    if ! command -v nc &> /dev/null; then
        log "ERROR" "netcat (nc) is required but not installed"
        log "ERROR" "Install it with: sudo apt-get install netcat (Ubuntu/Debian)"
        exit 1
    fi
    
    # Check if the serve directory exists
    if [ ! -d "$SERVE_DIR" ]; then
        log "ERROR" "Directory '$SERVE_DIR' does not exist"
        exit 1
    fi
    
    log "DEBUG" "All dependencies satisfied"
}

# Function to validate port number
validate_port() {
    if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        log "ERROR" "Invalid port number: $PORT (must be 1-65535)"
        exit 1
    fi
    
    # Check if port is already in use
    if nc -z localhost "$PORT" 2>/dev/null; then
        log "ERROR" "Port $PORT is already in use"
        exit 1
    fi
}

# Function to get MIME type based on file extension
get_mime_type() {
    local file="$1"
    local extension="${file##*.}"
    
    case "$extension" in
        html|htm)
            echo "text/html"
            ;;
        css)
            echo "text/css"
            ;;
        js)
            echo "application/javascript"
            ;;
        json)
            echo "application/json"
            ;;
        txt)
            echo "text/plain"
            ;;
        png)
            echo "image/png"
            ;;
        jpg|jpeg)
            echo "image/jpeg"
            ;;
        gif)
            echo "image/gif"
            ;;
        svg)
            echo "image/svg+xml"
            ;;
        *)
            echo "application/octet-stream"
            ;;
    esac
}

# Function to send HTTP response
send_response() {
    local status="$1"
    local content_type="$2"
    local content="$3"
    local content_length=${#content}
    
    # HTTP headers
    echo -e "HTTP/1.1 $status\r"
    echo -e "Server: $SERVER_NAME\r"
    echo -e "Date: $(date -u '+%a, %d %b %Y %H:%M:%S GMT')\r"
    echo -e "Content-Type: $content_type\r"
    echo -e "Content-Length: $content_length\r"
    echo -e "Connection: close\r"
    echo -e "\r"
    
    # HTTP body
    echo -n "$content"
}

# Function to send 404 error
send_404() {
    local path="$1"
    local content="<!DOCTYPE html>
<html>
<head>
    <title>404 Not Found</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        h1 { color: #e74c3c; }
    </style>
</head>
<body>
    <h1>404 Not Found</h1>
    <p>The requested file <code>$path</code> was not found on this server.</p>
    <p><a href=\"/\">← Back to Home</a></p>
    <hr>
    <p><em>$SERVER_NAME</em></p>
</body>
</html>"
    
    send_response "404 Not Found" "text/html" "$content"
}

# Function to handle HTTP request
handle_request() {
    local request_line
    local method
    local path
    local protocol
    
    # Read the request line
    read -r request_line
    log "DEBUG" "Request line: $request_line"
    
    # Parse the request line
    read -r method path protocol <<< "$request_line"
    
    # Remove carriage return from protocol
    protocol=${protocol%$'\r'}
    
    # Skip the rest of the headers
    while read -r line && [ "$line" != $'\r' ]; do
        log "DEBUG" "Header: $line"
    done
    
    # Only handle GET requests
    if [ "$method" != "GET" ]; then
        log "WARN" "Unsupported method: $method"
        send_response "405 Method Not Allowed" "text/plain" "Method Not Allowed"
        return
    fi
    
    # Clean the path (remove query parameters and decode URL)
    path=${path%%\?*}  # Remove query parameters
    path=$(printf '%b' "${path//%/\\x}")  # URL decode
    
    # Security: prevent directory traversal
    if [[ "$path" == *".."* ]]; then
        log "WARN" "Directory traversal attempt: $path"
        send_404 "$path"
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
        local content=$(cat "$file_path")
        send_response "200 OK" "$mime_type" "$content"
        log "INFO" "Served: $file_path ($mime_type)"
    else
        log "WARN" "File not found: $file_path"
        send_404 "$path"
    fi
}

# Function to start the server
start_server() {
    log "INFO" "Starting Bash Lite Server..."
    log "INFO" "Serving directory: $(realpath "$SERVE_DIR")"
    log "INFO" "Listening on port: $PORT"
    log "INFO" "Server URL: http://localhost:$PORT"
    log "INFO" "Press Ctrl+C to stop the server"
    echo
    
    # Create a temporary script that handles requests
    local handler_script="/tmp/bash_server_handler_$$"
    cat > "$handler_script" << 'EOF'
#!/bin/bash

# Copy necessary variables and functions
SERVE_DIR="SERVE_DIR_PLACEHOLDER"
SERVER_NAME="SERVER_NAME_PLACEHOLDER"
VERBOSE=VERBOSE_PLACEHOLDER

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} ${timestamp} - $message" >&2
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} ${timestamp} - $message" >&2
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${timestamp} - $message" >&2
            ;;
        "DEBUG")
            if [ "$VERBOSE" = true ]; then
                echo -e "${BLUE}[DEBUG]${NC} ${timestamp} - $message" >&2
            fi
            ;;
    esac
}

# MIME type function
get_mime_type() {
    local file="$1"
    local extension="${file##*.}"
    
    case "$extension" in
        html|htm) echo "text/html" ;;
        css) echo "text/css" ;;
        js) echo "application/javascript" ;;
        json) echo "application/json" ;;
        txt) echo "text/plain" ;;
        png) echo "image/png" ;;
        jpg|jpeg) echo "image/jpeg" ;;
        gif) echo "image/gif" ;;
        svg) echo "image/svg+xml" ;;
        *) echo "application/octet-stream" ;;
    esac
}

# Response function
send_response() {
    local status="$1"
    local content_type="$2"
    local content="$3"
    local content_length=${#content}
    
    echo -e "HTTP/1.1 $status\r"
    echo -e "Server: $SERVER_NAME\r"
    echo -e "Date: $(date -u '+%a, %d %b %Y %H:%M:%S GMT')\r"
    echo -e "Content-Type: $content_type\r"
    echo -e "Content-Length: $content_length\r"
    echo -e "Connection: close\r"
    echo -e "\r"
    echo -n "$content"
}

# 404 function
send_404() {
    local path="$1"
    local content="<!DOCTYPE html>
<html>
<head>
    <title>404 Not Found</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        h1 { color: #e74c3c; }
    </style>
</head>
<body>
    <h1>404 Not Found</h1>
    <p>The requested file <code>$path</code> was not found on this server.</p>
    <p><a href=\"/\">← Back to Home</a></p>
    <hr>
    <p><em>$SERVER_NAME</em></p>
</body>
</html>"
    
    send_response "404 Not Found" "text/html" "$content"
}

# Main request handler
read -r request_line
log "DEBUG" "Request line: $request_line"

read -r method path protocol <<< "$request_line"
protocol=${protocol%$'\r'}

while read -r line && [ "$line" != $'\r' ]; do
    log "DEBUG" "Header: $line"
done

if [ "$method" != "GET" ]; then
    log "WARN" "Unsupported method: $method"
    send_response "405 Method Not Allowed" "text/plain" "Method Not Allowed"
    exit 0
fi

path=${path%%\?*}
path=$(printf '%b' "${path//%/\\x}")

if [[ "$path" == *".."* ]]; then
    log "WARN" "Directory traversal attempt: $path"
    send_404 "$path"
    exit 0
fi

if [ "$path" = "/" ]; then
    path="/index.html"
fi

file_path="$SERVE_DIR$path"
log "INFO" "$method $path"

if [ -f "$file_path" ] && [ -r "$file_path" ]; then
    mime_type=$(get_mime_type "$file_path")
    content=$(cat "$file_path")
    send_response "200 OK" "$mime_type" "$content"
    log "INFO" "Served: $file_path ($mime_type)"
else
    log "WARN" "File not found: $file_path"
    send_404 "$path"
fi
EOF
    
    # Replace placeholders with actual values
    sed -i "s|SERVE_DIR_PLACEHOLDER|$SERVE_DIR|g" "$handler_script"
    sed -i "s|SERVER_NAME_PLACEHOLDER|$SERVER_NAME|g" "$handler_script"
    sed -i "s|VERBOSE_PLACEHOLDER|$VERBOSE|g" "$handler_script"
    chmod +x "$handler_script"
    
    # Cleanup function for the script
    local cleanup_script() {
        rm -f "$handler_script"
    }
    trap cleanup_script EXIT
    
    # Start the server loop
    while true; do
        # Use netcat to listen and execute our handler script
        nc -l -p "$PORT" -e "$handler_script"
        
        # Small delay to prevent overwhelming the system
        sleep 0.1
    done
}

# Signal handler for graceful shutdown
cleanup() {
    echo
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
    check_dependencies
    validate_port
    
    # Start the server
    start_server
}

# Run the main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
