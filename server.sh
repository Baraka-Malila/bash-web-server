#!/bin/bash

# Pilipili Server - HTTP Request Handler for socat
# Version: 1.0.0
# Based on bashttpd approach - reads HTTP request from stdin, writes response to stdout

# Configuration from environment variables
PORT=${PORT:-8080}
SERVE_DIR=${SERVE_DIR:-"./public"}
VERBOSE=${VERBOSE:-false}
SERVER_NAME=${SERVER_NAME:-"Pilipili-Server/1.0"}

# Function to log messages to stderr (so they don't interfere with HTTP response)
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    if [ "$VERBOSE" = true ] || [ "$level" = "ERROR" ]; then
        echo "[$level] $timestamp - $message" >&2
    fi
}

# Function to get MIME type based on file extension
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
        ico) echo "image/x-icon" ;;
        *) echo "application/octet-stream" ;;
    esac
}

# Function to send HTTP response
send_response() {
    local status="$1"
    local content_type="$2"
    local content="$3"
    
    # Calculate content length in bytes
    local content_length=${#content}
    
    # Send HTTP response headers
    printf "HTTP/1.1 %s\r\n" "$status"
    printf "Server: %s\r\n" "$SERVER_NAME"
    printf "Date: %s\r\n" "$(date -u '+%a, %d %b %Y %H:%M:%S GMT')"
    printf "Content-Type: %s\r\n" "$content_type"
    printf "Content-Length: %d\r\n" "$content_length"
    printf "Connection: close\r\n"
    printf "\r\n"
    
    # Send content (use printf to avoid adding newline)
    printf "%s" "$content"
}

# Function to send 404 error
send_404() {
    local path="$1"
    local content="<!DOCTYPE html>
<html>
<head>
    <title>404 Not Found - Pilipili Server</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            margin-top: 50px; 
            background-color: #f8f9fa;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 { color: #e74c3c; margin-bottom: 1rem; }
        .spicy { font-size: 3rem; margin-bottom: 1rem; }
        code { background: #f1f1f1; padding: 2px 6px; border-radius: 3px; }
        a { color: #3498db; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .footer { margin-top: 2rem; color: #666; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class=\"container\">
        <div class=\"spicy\">🌶️</div>
        <h1>404 Not Found</h1>
        <p>The requested file <code>$path</code> was not found on this server.</p>
        <p><a href=\"/\">← Back to Home</a></p>
        <div class=\"footer\">
            <em>$SERVER_NAME</em>
        </div>
    </div>
</body>
</html>"
    
    send_response "404 Not Found" "text/html" "$content"
}

# Main HTTP request handler
# Reads HTTP request from stdin and sends response to stdout
main() {
    local request_line method path protocol
    
    # Read the HTTP request line
    read -r request_line || {
        log "ERROR" "Failed to read request line"
        return 1
    }
    
    # Remove carriage return
    request_line=${request_line%$'\r'}
    
    log "DEBUG" "Request line: $request_line"
    
    # Skip all HTTP headers until we reach the empty line
    while read -r line; do
        line=${line%$'\r'}
        [ -z "$line" ] && break
        log "DEBUG" "Header: $line"
    done
    
    # Parse the request line
    read -r method path protocol <<< "$request_line"
    
    # Validate request method
    if [ "$method" != "GET" ]; then
        log "WARN" "Unsupported method: $method"
        send_response "405 Method Not Allowed" "text/plain" "Method Not Allowed"
        return
    fi
    
    # Clean and validate the path
    path=${path%%\?*}  # Remove query parameters
    
    # Security: prevent directory traversal
    if [[ "$path" == *".."* ]]; then
        log "WARN" "Directory traversal attempt blocked: $path"
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
        local mime_type
        mime_type=$(get_mime_type "$file_path")
        
        # Read file content
        local content
        if content=$(cat "$file_path" 2>/dev/null); then
            send_response "200 OK" "$mime_type" "$content"
            log "INFO" "Served: $file_path ($mime_type, ${#content} bytes)"
        else
            log "ERROR" "Failed to read file: $file_path"
            send_404 "$path"
        fi
    else
        log "WARN" "File not found: $file_path"
        send_404 "$path"
    fi
}

# Run the main function
main "$@"

