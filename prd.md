# Bash Lite Server - Product Requirements

## Goal
Build a simple static file web server in **pure Bash** (no Python, no Node) to serve `.html` files over `http://localhost:PORT`.

## Requirements

### 1. Server Features
- [ ] Listen on a given port (default: 8080).
- [ ] Serve files from a directory like `./public`.
- [ ] Respond to HTTP GET requests only.
- [ ] Serve default `index.html` if path is `/`.
- [ ] Serve other `.html` files if requested (`GET /about.html`).
- [ ] Send proper HTTP headers (`200 OK`, `404 Not Found`, etc.).
- [ ] Handle multiple requests one-by-one (no need for concurrency).

### 2. Constraints
- Pure Bash.
- Can use built-in tools (`nc`, `cat`, `echo`, `date`, `file`, etc.).
- No `python`, `node`, `curl`, etc.
- No background servers. Just run `bash server.sh`.

### 3. Directory Structure
```
bash-lite-server/
├── server.sh
├── public/
│   └── index.html
```

### 4. Optional Features (Milestone 2)
- [ ] Add logging (`access.log`).
- [ ] Guess MIME types (e.g., `.css`, `.js`).
- [ ] Directory listing if no index.html.
- [ ] Add `--help` and `--port` CLI args.

## Success Criteria
- Can visit `http://localhost:8080` in browser.
- Sees content of `public/index.html`.
- No external dependencies.
