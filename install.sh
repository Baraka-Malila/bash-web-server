#!/bin/bash

# Bash Lite Server - Installation Script
# Installs bash-lite-server to system or user directory

set -euo pipefail

VERSION="1.0.0"
REPO_URL="https://github.com/cyberpunk/bash-lite-server"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

show_help() {
    cat << 'EOF'
Bash Lite Server Installation Script

USAGE:
    curl -sSL https://raw.githubusercontent.com/cyberpunk/bash-lite-server/main/install.sh | bash
    
    Or download and run locally:
    ./install.sh [OPTIONS]

OPTIONS:
    --user          Install to user directory (~/.local/bin)
    --system        Install to system directory (/usr/local/bin) [requires sudo]
    --prefix PATH   Install to custom prefix (PATH/bin)
    --help          Show this help

DEFAULT: Installs to ~/.local/bin if writable, otherwise asks for permission
EOF
}

# Default installation directory
detect_install_dir() {
    if [[ "$EUID" -eq 0 ]]; then
        echo "/usr/local/bin"
    elif [[ -w "$HOME/.local/bin" ]] || mkdir -p "$HOME/.local/bin" 2>/dev/null; then
        echo "$HOME/.local/bin"
    else
        echo "/usr/local/bin"
    fi
}

# Parse arguments
INSTALL_DIR=""
FORCE_USER=false
FORCE_SYSTEM=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --user)
            FORCE_USER=true
            shift
            ;;
        --system)
            FORCE_SYSTEM=true
            shift
            ;;
        --prefix)
            INSTALL_DIR="$2/bin"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Determine installation directory
if [ "$FORCE_USER" = true ]; then
    INSTALL_DIR="$HOME/.local/bin"
elif [ "$FORCE_SYSTEM" = true ]; then
    INSTALL_DIR="/usr/local/bin"
elif [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR=$(detect_install_dir)
fi

log "Installing Bash Lite Server v${VERSION}..."
log "Installation directory: $INSTALL_DIR"

# Create installation directory
if ! mkdir -p "$INSTALL_DIR" 2>/dev/null; then
    warn "Cannot write to $INSTALL_DIR, trying with sudo..."
    sudo mkdir -p "$INSTALL_DIR"
    NEED_SUDO=true
fi

# Check if we're in the repo directory
if [ -f "./bash-lite-server" ] && [ -f "./server.sh" ]; then
    log "Installing from local repository..."
    
    # Copy main executable
    if [ "${NEED_SUDO:-false}" = true ]; then
        sudo cp ./bash-lite-server "$INSTALL_DIR/"
        sudo chmod +x "$INSTALL_DIR/bash-lite-server"
    else
        cp ./bash-lite-server "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/bash-lite-server"
    fi
    
    # Create lib directory for support scripts
    LIB_DIR="$INSTALL_DIR/../lib/bash-lite-server"
    if [ "${NEED_SUDO:-false}" = true ]; then
        sudo mkdir -p "$LIB_DIR"
        sudo cp server*.sh demo-pure.sh client-pure.sh "$LIB_DIR/"
        sudo cp -r public "$LIB_DIR/"
    else
        mkdir -p "$LIB_DIR"
        cp server*.sh demo-pure.sh client-pure.sh "$LIB_DIR/"
        cp -r public "$LIB_DIR/"
    fi
    
else
    log "Downloading from GitHub..."
    
    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download and extract
    curl -sSL "${REPO_URL}/archive/main.tar.gz" | tar xz --strip-components=1
    
    # Install
    if [ "${NEED_SUDO:-false}" = true ]; then
        sudo cp ./bash-lite-server "$INSTALL_DIR/"
        sudo chmod +x "$INSTALL_DIR/bash-lite-server"
        sudo mkdir -p "$INSTALL_DIR/../lib/bash-lite-server"
        sudo cp server*.sh demo-pure.sh client-pure.sh "$INSTALL_DIR/../lib/bash-lite-server/"
        sudo cp -r public "$INSTALL_DIR/../lib/bash-lite-server/"
    else
        cp ./bash-lite-server "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/bash-lite-server"
        mkdir -p "$INSTALL_DIR/../lib/bash-lite-server"
        cp server*.sh demo-pure.sh client-pure.sh "$INSTALL_DIR/../lib/bash-lite-server/"
        cp -r public "$INSTALL_DIR/../lib/bash-lite-server/"
    fi
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
fi

log "✅ Installation complete!"
echo
log "🚀 Quick start:"
echo "    bash-lite-server                # Start server on port 8080"
echo "    bash-lite-server --help         # Show help"
echo "    bash-lite-server --demo         # Interactive demo"
echo

# Check if install dir is in PATH
if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
    log "✅ $INSTALL_DIR is in your PATH"
else
    warn "⚠️  $INSTALL_DIR is not in your PATH"
    log "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo "    export PATH=\"$INSTALL_DIR:\$PATH\""
fi

log "📚 Documentation: $REPO_URL"
log "🎉 Happy serving!"
