#!/bin/bash

# ULTRA PURE Bash Web Server - Using ONLY Bash built-ins!
# No external tools whatsoever - pure shell scripting magic!
# Author: Generated with GitHub Copilot
# Version: 1.0 (Ultra Pure Edition)

# NOTE: This is a demonstration of pure Bash capabilities.
# For practical use, the netcat version is recommended.

# Default configuration
DEFAULT_PORT=8080
DEFAULT_DIR="./public"
SERVER_NAME="Ultra-Pure-Bash-Server/1.0"

# Global variables
PORT=$DEFAULT_PORT
SERVE_DIR=$DEFAULT_DIR
VERBOSE=false

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print colored output (using only printf)
log() {
    local level=$1
    shift
    local message="$*"
    
    # Get timestamp using bash built-ins only
    local timestamp=$(printf '%(%Y-%m-%d %H:%M:%S)T' -1)
    
    case $level in
        "INFO")
            printf "${GREEN}[INFO]${NC} ${timestamp} - %s\n" "$message" >&2
            ;;
        "WARN")
            printf "${YELLOW}[WARN]${NC} ${timestamp} - %s\n" "$message" >&2
            ;;
        "ERROR")
            printf "${RED}[ERROR]${NC} ${timestamp} - %s\n" "$message" >&2
            ;;
        "DEBUG")
            if [ "$VERBOSE" = true ]; then
                printf "${BLUE}[DEBUG]${NC} ${timestamp} - %s\n" "$message" >&2
            fi
            ;;
    esac
}

# Function to show help
show_help() {
    printf "Ultra Pure Bash Web Server - Using ONLY Bash built-ins!\n\n"
    printf "Usage: %s [OPTIONS]\n\n" "$0"
    printf "Options:\n"
    printf "    -p, --port PORT     Port to listen on (default: %d)\n" "$DEFAULT_PORT"
    printf "    -d, --dir DIR       Directory to serve files from (default: %s)\n" "$DEFAULT_DIR"
    printf "    -v, --verbose       Enable verbose logging\n"
    printf "    -h, --help          Show this help message\n\n"
    printf "Examples:\n"
    printf "    %s                  # Start server on port %d\n" "$0" "$DEFAULT_PORT"
    printf "    %s --port 3000      # Start server on port 3000\n" "$0"
    printf "\n🚀 This version uses ONLY Bash built-ins!\n"
    printf "📝 For demo purposes - serves static content via file system\n\n"
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

# Function to get MIME type (pure bash)
get_mime_type() {
    local file="$1"
    local extension="${file##*.}"
    
    case "$extension" in
        html|htm) printf "text/html" ;;
        css) printf "text/css" ;;
        js) printf "application/javascript" ;;
        json) printf "application/json" ;;
        txt) printf "text/plain" ;;
        png) printf "image/png" ;;
        jpg|jpeg) printf "image/jpeg" ;;
        gif) printf "image/gif" ;;
        svg) printf "image/svg+xml" ;;
        *) printf "application/octet-stream" ;;
    esac
}

# Function to read entire file (pure bash - replaces cat)
read_file() {
    local file="$1"
    local content=""
    local line
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        content="${content}${line}"$'\n'
    done < "$file"
    
    # Remove trailing newline if file didn't end with one
    if [[ -n "$content" ]]; then
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
    
    while [ $i -lt ${#input} ]; do
        char="${input:$i:1}"
        if [ "$char" = "%" ] && [ $((i+2)) -lt ${#input} ]; then
            local hex="${input:$((i+1)):2}"
            # Simple hex to char conversion for common cases
            case "$hex" in
                "20") char=" " ;;
                "21") char="!" ;;
                "22") char="\"" ;;
                "23") char="#" ;;
                "24") char="$" ;;
                "25") char="%" ;;
                "26") char="&" ;;
                "27") char="'" ;;
                "28") char="(" ;;
                "29") char=")" ;;
                "2A") char="*" ;;
                "2B") char="+" ;;
                "2C") char="," ;;
                "2D") char="-" ;;
                "2E") char="." ;;
                "2F") char="/" ;;
                *) char="?" ;;  # Unknown encoding
            esac
            i=$((i+3))
        else
            i=$((i+1))
        fi
        output="${output}${char}"
    done
    
    printf "%s" "$output"
}

# Function to generate HTTP response
generate_response() {
    local path="$1"
    local status
    local content_type
    local content
    
    # Clean the path
    path=${path%%\?*}  # Remove query parameters
    path=$(url_decode "$path")
    
    # Security: prevent directory traversal
    if [[ "$path" == *".."* ]]; then
        log "WARN" "Directory traversal attempt: $path"
        path="/index.html"
    fi
    
    # Default to index.html for root
    if [ "$path" = "/" ]; then
        path="/index.html"
    fi
    
    local file_path="$SERVE_DIR$path"
    
    # Check if file exists
    if [ -f "$file_path" ] && [ -r "$file_path" ]; then
        status="200 OK"
        content_type=$(get_mime_type "$file_path")
        content=$(read_file "$file_path")
        log "INFO" "Served: $path ($content_type)"
    else
        status="404 Not Found"
        content_type="text/html"
        content="<!DOCTYPE html>
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
        <p>The requested file <code>$path</code> was not found.</p>
        <p><a href=\"/\">← Back to Home</a></p>
        <hr>
        <p><em>$SERVER_NAME</em></p>
    </div>
</body>
</html>"
        log "WARN" "File not found: $path"
    fi
    
    # Generate HTTP response
    local response="HTTP/1.1 $status\r
Server: $SERVER_NAME\r
Date: $(printf '%(%a, %d %b %Y %H:%M:%S GMT)T' -1)\r
Content-Type: $content_type\r
Content-Length: ${#content}\r
Connection: close\r
\r
$content"
    
    printf "%s" "$response"
}

# Pure Bash TCP client function
tcp_connect() {
    local host="$1"
    local port="$2"
    local data="$3"
    
    # Open TCP connection using bash's /dev/tcp
    exec 3<>"/dev/tcp/$host/$port"
    
    # Send data
    printf "%s" "$data" >&3
    
    # Read response
    local response=""
    local line
    while read -r line <&3; do
        response="${response}${line}"$'\n'
    done
    
    # Close connection
    exec 3<&-
    exec 3>&-
    
    printf "%s" "$response"
}

# Function to start the pure bash server
start_server() {
    log "INFO" "Starting Ultra Pure Bash Web Server..."
    log "INFO" "Serving directory: $SERVE_DIR"
    log "INFO" "Mode: File-based HTTP server (pure Bash demo)"
    printf "\n"
    
    # Check if directory exists
    if [ ! -d "$SERVE_DIR" ]; then
        log "ERROR" "Directory '$SERVE_DIR' does not exist"
        exit 1
    fi
    
    printf "${GREEN}🚀 Ultra Pure Bash Web Server${NC}\n"
    printf "${BLUE}═══════════════════════════════════════${NC}\n\n"
    
    printf "Since pure Bash cannot create server sockets, this demo shows\n"
    printf "how to generate HTTP responses using only Bash built-ins!\n\n"
    
    printf "${YELLOW}Available commands:${NC}\n"
    printf "  serve <path>     - Generate HTTP response for a path\n"
    printf "  list             - List available files\n"
    printf "  test             - Run test requests\n"
    printf "  help             - Show this help\n"
    printf "  quit             - Exit server\n\n"
    
    # Interactive mode
    while true; do
        printf "${GREEN}pure-bash-server>${NC} "
        read -r command args
        
        case "$command" in
            "serve")
                local path="${args:-/}"
                printf "\n${BLUE}HTTP Response for '$path':${NC}\n"
                printf "────────────────────────────────────────\n"
                generate_response "$path"
                printf "\n────────────────────────────────────────\n\n"
                ;;
            "list")
                printf "\n${BLUE}Available files in $SERVE_DIR:${NC}\n"
                local file
                for file in "$SERVE_DIR"/*; do
                    if [ -f "$file" ]; then
                        local basename="${file##*/}"
                        local mime=$(get_mime_type "$file")
                        printf "  /%s (%s)\n" "$basename" "$mime"
                    fi
                done
                printf "\n"
                ;;
            "test")
                printf "\n${BLUE}Running test requests:${NC}\n"
                printf "────────────────────────────────────────\n"
                
                # Test index page
                printf "${YELLOW}Testing GET /${NC}\n"
                generate_response "/" | head -10
                printf "...\n\n"
                
                # Test 404
                printf "${YELLOW}Testing GET /nonexistent${NC}\n"
                generate_response "/nonexistent" | head -10
                printf "...\n"
                printf "────────────────────────────────────────\n\n"
                ;;
            "help")
                printf "\n${BLUE}Pure Bash HTTP Response Generator${NC}\n"
                printf "This demonstrates HTTP response generation using only Bash built-ins.\n"
                printf "No external tools like cat, date, or nc are used!\n\n"
                ;;
            "quit"|"exit"|"q")
                log "INFO" "Shutting down server..."
                break
                ;;
            "")
                continue
                ;;
            *)
                printf "Unknown command: %s (try 'help')\n\n" "$command"
                ;;
        esac
    done
}

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
    
    # Start the server
    start_server
}

# Run the main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
