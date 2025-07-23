# Bash Lite Server Documentation

## Quick Navigation

- **[Getting Started](getting-started.md)** - Installation and first run
- **[Usage Guide](usage.md)** - Command line options and examples  
- **[Configuration](configuration.md)** - Customization options
- **[Examples](examples.md)** - Real-world use cases
- **[Development](development.md)** - For contributors and developers
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions

## Architecture

Bash Lite Server consists of:

- **`bash-lite-server`** - Main entry point and CLI interface
- **`server.sh`** - Core HTTP server implementation
- **`server-ultra-pure.sh`** - Educational pure Bash version
- **`server-tiny-pure.sh`** - Minimal implementation (20 lines)
- **`demo-pure.sh`** - Interactive learning tool
- **`client-pure.sh`** - Pure Bash HTTP client

## Project Structure

```
bash-lite-server/
├── bash-lite-server          # Main executable
├── server.sh                 # Core server (production)
├── server-ultra-pure.sh      # Educational version
├── server-tiny-pure.sh       # Minimal version
├── demo-pure.sh              # Interactive demo
├── client-pure.sh            # HTTP client
├── install.sh                # Installation script
├── public/                   # Default web content
├── examples/                 # Example websites
├── docs/                     # Documentation
└── tests/                    # Test suite
```
