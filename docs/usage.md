# Usage Guide

## Command Line Interface

```bash
pilipili-server [OPTIONS] [DIRECTORY]
```

### Options

| Option | Description | Example |
|--------|-------------|---------|
| `-p, --port PORT` | Port to listen on | `pilipili-server -p 3000` |
| `-h, --help` | Show help message | `pilipili-server --help` |
| `-v, --version` | Show version | `pilipili-server --version` |
| `--verbose` | Enable detailed logging | `pilipili-server --verbose` |

### Directory Argument

The directory argument specifies which folder to serve files from.

```bash
pilipili-server                 # Serves ./public
pilipili-server ./docs         # Serves ./docs  
pilipili-server /var/www/html   # Serves /var/www/html
```

## Common Use Cases

### 1. Local Development Server
```bash
# Serve your website during development
cd my-project
pilipili-server ./dist -p 3000 --verbose
```

### 2. Quick File Sharing
```bash
# Share files over HTTP on local network
pilipili-server ~/Documents -p 8000
# Access from other devices: http://YOUR_IP:8000
```

### 3. Static Site Preview
```bash
# Preview static site generator output
pilipili-server ./_site
pilipili-server ./build
pilipili-server ./public
```

### 4. Documentation Server
```bash
# Serve documentation locally
pilipili-server ./docs -p 4000
```

## Server Behavior

### File Serving
- **Index files**: `index.html` is served for directory requests
- **MIME types**: Automatically detected based on file extension
- **404 handling**: Custom 404 page for missing files
- **Security**: Directory traversal protection built-in

### Supported File Types
| Extension | MIME Type |
|-----------|-----------|
| `.html`, `.htm` | `text/html` |
| `.css` | `text/css` |
| `.js` | `application/javascript` |
| `.json` | `application/json` |
| `.txt` | `text/plain` |
| `.png` | `image/png` |
| `.jpg`, `.jpeg` | `image/jpeg` |
| `.gif` | `image/gif` |
| `.svg` | `image/svg+xml` |

### Logging
With `--verbose` enabled, you'll see:
- Request details (method, path, response code)
- File access information
- Error messages
- Server startup information

```bash
[INFO] 2025-07-23 10:30:45 - Starting Bash Lite Server...
[INFO] 2025-07-23 10:30:45 - Serving directory: /home/user/website
[INFO] 2025-07-23 10:30:45 - Listening on port: 8080
[INFO] 2025-07-23 10:30:45 - Server URL: http://localhost:8080
```

## Stopping the Server

- **Ctrl+C** - Graceful shutdown
- **Kill process** - `kill PID` or `pkill -f bash-lite-server`

## Tips and Tricks

### 1. Find Your IP Address
```bash
# Linux/macOS
ip addr show | grep inet
# or
ifconfig | grep inet
```

### 2. Test Server Response
```bash
# Test with curl
curl -v http://localhost:8080

# Test specific file
curl http://localhost:8080/index.html
```

### 3. Monitor Logs
```bash
# Run with verbose logging
bash-lite-server --verbose 2>&1 | tee server.log
```

### 4. Background Execution
```bash
# Run in background
nohup bash-lite-server > server.log 2>&1 &

# Check if running
ps aux | grep bash-lite-server
```
