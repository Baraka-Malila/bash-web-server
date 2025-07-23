# Bash Lite Server

A simple static file web server written in **pure Bash** - no Node.js, no Python, just shell scripting!

## Features

- 🚀 Pure Bash implementation
- 📁 Serves static HTML files from `public/` directory
- 🌐 HTTP/1.1 compliant responses
- 📝 Request logging
- 🔧 Configurable port (default: 8080)

## Quick Start

1. **Clone and navigate to the project:**
   ```bash
   cd bash-lite-server
   ```

2. **Make the server executable:**
   ```bash
   chmod +x server.sh
   ```

3. **Start the server:**
   ```bash
   ./server.sh
   ```

4. **Visit in your browser:**
   ```
   http://localhost:8080
   ```

## Usage

```bash
# Start on default port (8080)
./server.sh

# Start on custom port
./server.sh --port 3000

# Show help
./server.sh --help
```

## Project Structure

```
bash-lite-server/
├── server.sh          # Main server script
├── public/             # Static files directory
│   └── index.html     # Default page
├── README.md          # This file
└── prd.md             # Product requirements
```

## Adding Content

Simply add HTML files to the `public/` directory:

```bash
# Add a new page
echo '<h1>About Page</h1>' > public/about.html

# Visit: http://localhost:8080/about.html
```

## Requirements

- Bash 4.0+ 
- `nc` (netcat) - usually pre-installed on Linux/macOS
- Standard Unix tools (`cat`, `date`, `file`, etc.)

## How It Works

The server uses `netcat` to listen for HTTP connections and processes each request with pure Bash:

1. 📡 Listen on specified port using `nc`
2. 📥 Parse incoming HTTP request
3. 📄 Serve appropriate file from `public/` directory
4. 📤 Send proper HTTP headers and response
5. 📝 Log the request

## License

MIT License - see LICENSE file for details.
