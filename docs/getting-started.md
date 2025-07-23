# Getting Started

## Quick Installation

### One-line Install
```bash
curl -sSL https://raw.githubusercontent.com/Baraka-Malila/pilipili-server/main/install.sh | bash
```

### Manual Install
```bash
git clone https://github.com/Baraka-Malila/pilipili-server.git
cd pilipili-server
chmod +x pilipili-server install.sh
./install.sh
```

### Local Development
```bash
git clone https://github.com/Baraka-Malila/pilipili-server.git
cd pilipili-server
./pilipili-server
```

## First Run

1. **Start the server:**
   ```bash
   pilipili-server
   ```

2. **Open your browser:**
   Visit `http://localhost:8080`

3. **Success!**
   You should see the welcome page

## Basic Usage

```bash
# Default: serve ./public on port 8080
pilipili-server

# Custom port
pilipili-server -p 3000

# Custom directory
pilipili-server ./my-website

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
