#!/bin/bash

# ULTIMATE PURE BASH HTTP RESPONSE
# Only Bash built-ins - 20 lines of core logic!

http() {
    local path="${1#/}"; [ -z "$path" ] && path="index.html"
    local file="public/$path" content="" line
    
    # Read file with pure Bash
    if [ -f "$file" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            content+="$line"$'\n'
        done < "$file"
        content="${content%$'\n'}"
        printf "HTTP/1.1 200 OK\r\nContent-Length: %d\r\n\r\n%s" "${#content}" "$content"
    else
        content="<h1>404 Not Found</h1><p>/$path not found</p>"
        printf "HTTP/1.1 404 Not Found\r\nContent-Length: %d\r\n\r\n%s" "${#content}" "$content"
    fi
}

# Demo
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    printf "PURE BASH HTTP GENERATOR (20 lines!)\n====================================\n\n"
    printf "GET /:\n"; http "/"; printf "\n\n"
    printf "GET /missing:\n"; http "/missing"
fi
