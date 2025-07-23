# Contributing to Pilipili Server 🌶️

Thank you for your interest in contributing to Pilipili Server! This document provides guidelines for contributing to this pure Bash web server project.

## 🚀 Quick Start for Contributors

1. **Fork the repository**
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/pilipili-server.git
   cd pilipili-server
   ```
3. **Make it executable**:
   ```bash
   chmod +x pilipili-server server.sh tests/test.sh
   ```
4. **Test it works**:
   ```bash
   ./pilipili-server
   ```

## 🎯 Ways to Contribute

### 🐛 Bug Reports
- Use the GitHub issue tracker
- Include steps to reproduce
- Mention your OS and Bash version
- Provide server logs if relevant

### ✨ Feature Requests
- Check existing issues first
- Describe the use case
- Keep it lightweight (remember, this is pure Bash!)

### 🔧 Code Contributions
- Follow existing code style
- Add tests for new features
- Update documentation
- Keep dependencies minimal

## 📝 Code Style

### Bash Best Practices
- Use `set -euo pipefail` for safety
- Quote variables: `"$variable"`
- Use `local` for function variables
- Prefer `[[ ]]` over `[ ]`
- Use meaningful function names

### Comments
- Document complex logic
- Explain non-obvious Bash tricks
- Add function headers for public functions

### Example:
```bash
# Function to handle HTTP requests
# Args: None (reads from stdin)
# Returns: HTTP response via stdout
handle_request() {
    local request_line method path protocol
    
    # Read and parse request line
    read -r request_line
    read -r method path protocol <<< "$request_line"
    
    # Security check
    if [[ "$path" == *".."* ]]; then
        send_404 "$path"
        return
    fi
    
    # ... rest of logic
}
```

## 🧪 Testing

### Running Tests
```bash
./tests/test.sh
```

### Adding Tests
Add test functions to `tests/test.sh`:
```bash
test_custom_feature() {
    # Test logic here
    run_test "Feature works" "test_command_here"
}
```

### Manual Testing
```bash
# Test basic functionality
./pilipili-server &
curl http://localhost:8080
kill %1

# Test different options
./pilipili-server -p 3000 ./examples/blog
```

## 📚 Documentation

- Update README.md for user-facing changes
- Update docs/ for detailed documentation
- Add examples to examples/ directory
- Keep documentation simple and clear

## 🌶️ Design Philosophy

Pilipili Server follows these principles:

1. **Pure Bash**: No external dependencies beyond standard Unix tools
2. **Lightweight**: Minimal resource usage
3. **Simple**: Easy to understand and modify
4. **Secure**: Basic security features built-in
5. **Educational**: Code should be readable and instructive

## 🔄 Pull Request Process

1. **Create feature branch**: `git checkout -b feature/awesome-feature`
2. **Make changes**: Follow code style guidelines
3. **Test thoroughly**: Run test suite and manual tests
4. **Update docs**: Update relevant documentation
5. **Commit**: Use clear, descriptive commit messages
6. **Push**: `git push origin feature/awesome-feature`
7. **Create PR**: Use the GitHub interface

### Commit Message Format
```
type(scope): description

- Use present tense: "add feature" not "added feature"
- Keep first line under 50 characters
- Use body to explain what and why, not how

Examples:
feat(server): add CORS header support
fix(security): prevent path traversal in URLs
docs(readme): update installation instructions
test(core): add integration tests for file serving
```

## 📋 Review Process

- Maintainers will review PRs within a week
- Address feedback promptly
- Keep PRs focused on single features/fixes
- Squash commits before merging

## 🏷️ Versioning

We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙋‍♂️ Questions?

- Open an issue for questions
- Check existing issues first
- Be respectful and patient

---

**Happy contributing! 🌶️**
