# 🚀 Bash Lite Server

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)
[![GitHub stars](https://img.shields.io/github/stars/cyberpunk/bash-lite-server.svg)](https://github.com/cyberpunk/bash-lite-server/stargazers)

A lightweight static file web server written in **pure Bash** - no Node.js, no Python, just shell scripting magic! 🪄

Perfect for learning HTTP protocols, quick development servers, or when you need a zero-dependency web server.

## ✨ Features

- 🚀 **Pure Bash implementation** - no external dependencies beyond standard Unix tools
- 📁 **Static file serving** from any directory
- 🌐 **HTTP/1.1 compliant** responses with proper headers
- 🎯 **Multiple purity levels** - from 20 lines to full-featured
- 📝 **Request logging** with colored output
- 🔧 **Configurable port** and directory
- 🛡️ **Security features** (directory traversal protection)
- 📱 **Modern responsive** default page
- 🎓 **Educational modes** for learning HTTP internals

## 🏃‍♂️ Quick Start

### One-line Installation
```bash
curl -sSL https://raw.githubusercontent.com/cyberpunk/bash-lite-server/main/install.sh | bash
```

### Manual Installation
```bash
git clone https://github.com/cyberpunk/bash-lite-server.git
cd bash-lite-server
chmod +x bash-lite-server
```

### Run Immediately
```bash
# Start server (serves ./public on port 8080)
./bash-lite-server

# Custom port and directory  
./bash-lite-server -p 3000 ./docs

# Ultra-pure mode (no external tools!)
./bash-lite-server --pure

# Interactive demo
./bash-lite-server --demo
```

Visit **http://localhost:8080** in your browser! 🎉

## 🎯 Usage Examples

```bash
# Basic usage
bash-lite-server                    # Serve ./public on port 8080
bash-lite-server -p 3000           # Custom port
bash-lite-server ./my-site         # Custom directory
bash-lite-server --verbose         # Enable detailed logging

# Advanced modes
bash-lite-server --pure            # Ultra-pure Bash (educational)
bash-lite-server --demo            # Interactive HTTP demo

# Get help
bash-lite-server --help
bash-lite-server --version
```

## 🏗️ Project Structure

```
bash-lite-server/
├── bash-lite-server           # Main entry point
├── server.sh                  # Full-featured server (uses netcat)
├── server-ultra-pure.sh       # Pure Bash demo (no external tools)
├── server-tiny-pure.sh        # Minimal implementation (20 lines!)
├── demo-pure.sh              # Interactive HTTP demo
├── client-pure.sh            # Pure Bash HTTP client
├── install.sh                # Installation script
├── public/                   # Default web root
│   └── index.html           # Welcome page
└── docs/                    # Documentation
```

## 🎓 Learning Modes

This project includes multiple implementations perfect for education:

### 1. **Standard Mode** (`server.sh`)
- Production-ready server using `netcat`
- Full HTTP/1.1 implementation
- Request logging and error handling

### 2. **Ultra-Pure Mode** (`server-ultra-pure.sh`) 
- Uses **ONLY** Bash built-ins
- No external tools (`cat`, `nc`, `date`, etc.)
- Perfect for understanding HTTP internals

### 3. **Minimal Mode** (`server-tiny-pure.sh`)
- Just 20 lines of core logic!
- Shows HTTP response generation basics

### 4. **Interactive Demo** (`demo-pure.sh`)
- Hands-on HTTP learning
- Test requests and responses
- TCP client examples

## 🔧 Requirements

**Standard Mode:**
- Bash 4.0+
- `nc` (netcat) - usually pre-installed
- Standard Unix tools (`cat`, `date`, `file`)

**Ultra-Pure Mode:**
- Bash 4.0+ only!
- No external dependencies

## 📚 How It Works

### Standard Server
1. 📡 Uses `netcat` to listen on specified port
2. 📥 Parses HTTP requests with Bash
3. 📄 Serves files from specified directory
4. 📤 Sends proper HTTP headers
5. 📝 Logs requests with colors

### Ultra-Pure Server
1. 🧠 Pure Bash HTTP response generation
2. 📖 File reading using only `while read`
3. 🕐 Timestamps with `printf '%T'`
4. 🌐 TCP client via `/dev/tcp`
5. 🎨 Everything with built-in features

## 🚀 Adding Content

Simply add files to the `public/` directory:

```bash
# Add pages
echo '<h1>About Page</h1>' > public/about.html
echo 'body { color: blue; }' > public/style.css

# Visit:
# http://localhost:8080/about.html
# http://localhost:8080/style.css
```

## 🎯 Use Cases

- 📖 **Learning HTTP protocols** and web fundamentals
- 🛠️ **Quick development server** for static sites
- 🐳 **Lightweight containers** and embedded systems
- 🎓 **Teaching shell scripting** and system programming
- 🔧 **Emergency web server** when nothing else is available

## 🤝 Contributing

Contributions welcome! Areas of interest:

- 🧪 **Tests and benchmarks**
- 📖 **Documentation and tutorials**
- 🔒 **Security improvements**
- 🌍 **Cross-platform compatibility**
- ⚡ **Performance optimizations**

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🌟 Star History

If you find this project useful, please consider giving it a star! ⭐

---

**Made with ❤️ and pure Bash** - No Node.js, Python, or fancy frameworks required!
