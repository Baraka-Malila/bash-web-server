#!/bin/bash

# MINIMAL PURE BASH HTTP RESPONSE GENERATOR
# Demonstrates HTTP response generation using ONLY Bash built-ins
# No external commands: no cat, no date, no nc, no file, etc.

# Generate HTTP response using only Bash built-ins
http_response() {
    local path="${1:-/}"
    local file_content=""
    local status="404 Not Found"
    local content_type="text/html"
    
    # Remove leading slash and default to index.html
    path="${path#/}"
    [ -z "$path" ] && path="index.html"
    
    # Try to read file using only Bash
    if [ -f "public/$path" ] && [ -r "public/$path" ]; then
        status="200 OK"
        
        # Determine content type from extension
        case "$path" in
            *.html|*.htm) content_type="text/html" ;;
            *.css) content_type="text/css" ;;
            *.js) content_type="application/javascript" ;;
            *.json) content_type="application/json" ;;
            *.txt) content_type="text/plain" ;;
            *) content_type="application/octet-stream" ;;
        esac
        
        # Read file content using only Bash
        while IFS= read -r line || [ -n "$line" ]; do
            file_content="${file_content}${line}"$'\n'
        done < "public/$path"
        
        # Remove trailing newline
        file_content="${file_content%$'\n'}"
    else
        # 404 response
        file_content="<!DOCTYPE html><html><head><title>404 Not Found</title></head><body><h1>404 Not Found</h1><p>File not found: /$path</p></body></html>"
    fi
    
    # Generate timestamp using Bash built-in
    local timestamp=$(printf '%(%a, %d %b %Y %H:%M:%S GMT)T' -1)
    
    # Build HTTP response
    printf "HTTP/1.1 %s\r\n" "$status"
    printf "Server: Minimal-Pure-Bash/1.0\r\n"
    printf "Date: %s\r\n" "$timestamp"
    printf "Content-Type: %s\r\n" "$content_type"
    printf "Content-Length: %d\r\n" "${#file_content}"
    printf "Connection: close\r\n"
    printf "\r\n"
    printf "%s" "$file_content"
}

# Demo function
demo() {
    printf "MINIMAL PURE BASH HTTP RESPONSE GENERATOR\n"
    printf "=========================================\n\n"
    
    printf "This script demonstrates HTTP response generation using ONLY Bash built-ins.\n"
    printf "No external tools are used - just pure shell scripting!\n\n"
    
    printf "Testing GET /:\n"
    printf "-------------\n"
    local response=$(http_response "/")
    printf "%s\n" "${response:0:300}..."
    printf "\n"
    
    printf "Testing GET /nonexistent:\n"
    printf "------------------------\n"
    local response=$(http_response "/nonexistent")
    printf "%s\n" "${response:0:300}..."
    printf "\n"
    
    printf "Available functions:\n"
    printf "  http_response <path>  - Generate HTTP response for a path\n"
    printf "  demo                  - Run this demo\n\n"
}

# Main execution
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    case "${1:-demo}" in
        "demo") demo ;;
        *) http_response "$1" ;;
    esac
fi
