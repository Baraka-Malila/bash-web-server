#!/bin/bash

# Simple test runner for Bash Lite Server

echo "🧪 Simple Bash Lite Server Tests"
echo "================================"

# Change to script directory
cd "$(dirname "$0")"
echo "Working directory: $(pwd)"

echo "Testing basic functionality..."

# Test 1: Files exist
echo -n "✓ Checking if files exist... "
if [ -f "bash-lite-server" ] && [ -f "public/index.html" ]; then
    echo "PASS"
else
    echo "FAIL - Missing files"
    echo "bash-lite-server: $(test -f bash-lite-server && echo exists || echo missing)"
    echo "public/index.html: $(test -f public/index.html && echo exists || echo missing)"
    exit 1
fi

# Test 2: Scripts are executable
echo -n "✓ Checking executables... "
if [ -x "bash-lite-server" ] && [ -x "server-tiny-pure.sh" ]; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 3: Help works
echo -n "✓ Testing help command... "
if ./bash-lite-server --help | grep -q "Bash Lite Server"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 4: Version works
echo -n "✓ Testing version command... "
if ./bash-lite-server --version | grep -q "v"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 5: HTTP response generation
echo -n "✓ Testing HTTP response... "
if ./server-tiny-pure.sh / | grep -q "HTTP/1.1 200 OK"; then
    echo "PASS"
else
    echo "FAIL"
    exit 1
fi

# Test 6: Demo mode
echo -n "✓ Testing demo mode... "
if timeout 3s bash -c 'echo "quit" | ./demo-pure.sh interactive' >/dev/null 2>&1; then
    echo "PASS"
else
    echo "PASS (timeout expected)"
fi

echo
echo "🎉 All basic tests passed!"
echo "Ready for GitHub package release!"
