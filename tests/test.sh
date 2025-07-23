#!/bin/bash

# Pilipili Server - Test Suite
# Tests basic functionality of all server implementations

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

log() {
    echo -e "${GREEN}[TEST]${NC} $*"
}

pass() {
    echo -e "${GREEN}✓ PASS:${NC} $*"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗ FAIL:${NC} $*"
    ((TESTS_FAILED++))
}

info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

run_test() {
    local test_name="$1"
    shift
    local cmd="$*"
    
    ((TESTS_RUN++))
    info "Running: $test_name"
    
    if eval "$cmd" >/dev/null 2>&1; then
        pass "$test_name"
        return 0
    else
        fail "$test_name"
        return 1
    fi
}

# Test HTTP response generation
test_http_responses() {
    log "Testing HTTP response generation..."
    
    # Test tiny pure server
    run_test "Tiny pure server generates response" \
        "./server-tiny-pure.sh / | grep -q 'HTTP/1.1 200 OK'"
    
    # Test minimal pure server  
    run_test "Minimal pure server generates response" \
        "./server-minimal-pure.sh / | grep -q 'HTTP/1.1 200 OK'"
    
    # Test 404 response
    run_test "404 response for missing file" \
        "./server-tiny-pure.sh /missing | grep -q 'HTTP/1.1 404 Not Found'"
}

# Test file operations
test_file_operations() {
    log "Testing file operations..."
    
    # Test file reading
    run_test "Can read index.html" \
        "test -r public/index.html"
    
    # Test directory structure
    run_test "Public directory exists" \
        "test -d public"
    
    # Test executables
    run_test "Main executable is executable" \
        "test -x pilipili-server"
    
    run_test "Server scripts are executable" \
        "test -x server.sh && test -x server-tiny-pure.sh"
}

# Test pure Bash features
test_pure_bash() {
    log "Testing pure Bash features..."
    
    # Test ultra-pure server
    run_test "Ultra-pure server runs" \
        "echo 'quit' | timeout 5s ./server-ultra-pure.sh"
    
    # Test TCP client (if network available)
    if command -v ping >/dev/null && ping -c 1 google.com >/dev/null 2>&1; then
        run_test "TCP client can connect" \
            "timeout 10s ./client-pure.sh google.com 80 / | grep -q 'HTTP'"
    else
        info "Skipping TCP test (no network)"
    fi
}

# Test CLI interface
test_cli() {
    log "Testing CLI interface..."
    
    run_test "Help option works" \
        "./pilipili-server --help | grep -q 'Pilipili Server'"
    
    run_test "Version option works" \
        "./pilipili-server --version | grep -q 'v[0-9]'"
}

# Performance test
test_performance() {
    log "Testing performance..."
    
    # Test response time
    local start_time=$(date +%s%N)
    echo '/' | ./server-tiny-pure.sh >/dev/null
    local end_time=$(date +%s%N)
    local duration=$(((end_time - start_time) / 1000000))  # Convert to milliseconds
    
    if [ "$duration" -lt 1000 ]; then  # Less than 1 second
        pass "Response generated in ${duration}ms (< 1000ms)"
    else
        fail "Response took ${duration}ms (> 1000ms)"
    fi
}

# Main test runner
main() {
    echo -e "${BLUE}🌶️ Pilipili Server Test Suite${NC}"
    echo "=================================="
    echo
    
    # Change to script directory
    cd "$(dirname "${BASH_SOURCE[0]}")/.."
    
    # Run test suites
    test_file_operations
    echo
    test_http_responses  
    echo
    test_pure_bash
    echo
    test_cli
    echo
    test_performance
    echo
    
    # Summary
    echo "=================================="
    echo -e "${BLUE}📊 Test Results${NC}"
    echo "Tests run: $TESTS_RUN"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
    
    if [ "$TESTS_FAILED" -eq 0 ]; then
        echo -e "\n${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ Some tests failed${NC}"
        exit 1
    fi
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
