#!/bin/bash

# Simple Test Suite for Pilipili Server

echo "🌶️ Pilipili Server - Quick Test"
echo "================================"

# Test 1: Check if main executable works
echo -n "✓ Main executable: "
if ./pilipili-server --version >/dev/null 2>&1; then
    echo "PASS"
else
    echo "FAIL"
fi

# Test 2: Check if public directory exists
echo -n "✓ Public directory: "
if [ -d "public" ]; then
    echo "PASS"
else
    echo "FAIL"
fi

# Test 3: Check if index.html exists
echo -n "✓ Index file: "
if [ -f "public/index.html" ]; then
    echo "PASS"
else
    echo "FAIL"
fi

# Test 4: Check server.sh responds
echo -n "✓ Server responds: "
if echo -e 'GET / HTTP/1.1\r\nHost: localhost\r\n\r' | SERVE_DIR=./public ./server.sh | grep -q "HTTP/1.1 200 OK"; then
    echo "PASS"
else
    echo "FAIL"
fi

echo
echo "🎉 Basic tests completed!"
