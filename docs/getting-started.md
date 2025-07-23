# Getting Started

## Quick Installation

### One-line Install
```bash
curl -sSL https://raw.githubusercontent.com/cyberpunk/bash-lite-server/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/cyberpunk/bash-lite-server.git
cd bash-lite-server
chmod +x bash-lite-server install.sh
./install.sh
```

### Local Development
```bash
git clone https://github.com/cyberpunk/bash-lite-server.git
cd bash-lite-server
./bash-lite-server
```

## First Run

1. **Start the server:**
   ```bash
   bash-lite-server
   ```

2. **Open your browser:**
   Visit `http://localhost:8080`

3. **Success!**
   You should see the welcome page

## Basic Usage

```bash
# Default: serve ./public on port 8080
bash-lite-server

# Custom port
bash-lite-server -p 3000

# Custom directory
bash-lite-server ./my-website

# Verbose logging
bash-lite-server --verbose

# Get help
bash-lite-server --help
```

## Requirements

- **Bash 4.0+** (check with `bash --version`)
- **netcat** (`nc`) - usually pre-installed on Linux/macOS
- **Standard Unix tools** (`cat`, `date`, `file`)

### Checking Requirements
```bash
# Check Bash version
bash --version

# Check if netcat is available
which nc

# Check if tools are available
which cat date file
```

## Next Steps

- Read the [Usage Guide](usage.md) for detailed options
- Check out [Examples](examples.md) for real-world use cases
- See [Configuration](configuration.md) for customization
