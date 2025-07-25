# 🌶️ Pilipili Server

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![npm version](https://badge.fury.io/js/pilipili-server.svg)](https://www.npmjs.com/package/pilipili-server)
[![npm downloads](https://img.shields.io/npm/dm/pilipili-server.svg)](https://www.npmjs.com/package/pilipili-server)

A spicy little web server written in **pure Bash** - no Node.js, no Python, just shell scripting! 🌶️

Perfect for local development, quick file sharing, or learning HTTP fundamentals.

## ✨ Features

- 🌶️ **Small but powerful** - like a pepper!
- 📁 **Static file serving** with automatic MIME type detection
- 🌐 **HTTP/1.1 compliant** responses
- 🔧 **Simple CLI** with intuitive options
- 📝 **Request logging** with optional verbose mode
- 🛡️ **Security features** (directory traversal protection)
- ⚡ **Lightweight** - perfect for containers and embedded systems

## 🏃‍♂️ Quick Start

### Installation Methods

#### Method 1: npm Install (Recommended)
```bash
# From npmjs.com (main registry)
npm install -g pilipili-server

# Or from GitHub Packages
npm install -g @baraka-malila/pilipili-server
```

#### Method 2: Direct Install Script
```bash
curl -sSL https://raw.githubusercontent.com/Baraka-Malila/pilipili-server/main/install.sh | bash
```

#### Method 3: Manual Install
```bash
git clone https://github.com/Baraka-Malila/pilipili-server.git
cd pilipili-server
chmod +x pilipili-server install.sh
./install.sh
```

### Usage
```bash
# Start server (serves ./public on port 8080)
pilipili-server

# Custom port and directory
pilipili-server -p 3000 ./my-website

# Enable verbose logging
pilipili-server --verbose
```

Visit **http://localhost:8080** in your browser! 🎉

## 📖 Documentation

- **[Getting Started](docs/getting-started.md)** - Installation and first run
- **[Usage Guide](docs/usage.md)** - Command line options and examples
- **[Examples](docs/examples.md)** - Real-world use cases

## 🎯 Use Cases

- **Local development** - Quick server for static sites
- **File sharing** - Share files over HTTP on local network  
- **Learning** - Understand HTTP protocols and Bash scripting
- **Containers** - Lightweight web server for Docker/embedded systems

## 🔧 Requirements

- Bash 4.0+
- `socat` (recommended) or `netcat` for socket handling
- Standard Unix tools (`cat`, `date`, `file`)

**Note:** `socat` is highly recommended for production use as it provides better connection handling and concurrent request support. The server will automatically fall back to `netcat` if `socat` is not available.

### Installing socat
```bash
# Ubuntu/Debian
sudo apt-get install socat

# CentOS/RHEL/Fedora
sudo yum install socat
# or
sudo dnf install socat

# macOS
brew install socat
```

## 📁 Project Structure

```
pilipili-server/
├── pilipili-server           # Main executable 🌶️
├── server.sh                 # Core HTTP server
├── public/                   # Default web content
├── docs/                     # Documentation
└── examples/                 # Example websites
```

## 🤝 Contributing

Contributions welcome! Please read our [development guide](docs/development.md).

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Made with ❤️ and pure Bash** - Small, fast, and spicy! 🌶️
