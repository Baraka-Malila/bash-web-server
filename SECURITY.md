# Security Policy

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | ✅ Yes             |
| < 1.0   | ❌ No              |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### 🚨 For Security Issues

**DO NOT** open a public GitHub issue for security vulnerabilities.

Instead, please:

1. **Email**: Send details to security@example.com (or create a private security advisory on GitHub)
2. **Include**:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if you have one)

### 🕐 Response Timeline

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 1 week  
- **Fix Timeline**: Depends on severity
  - Critical: Within 7 days
  - High: Within 30 days
  - Medium/Low: Next regular release

### 🛡️ Current Security Features

Pilipili Server includes these security measures:

- **Directory Traversal Protection**: Prevents `../` path manipulation
- **Input Validation**: Basic validation of HTTP requests
- **File Access Control**: Only serves files from designated directory
- **No Code Execution**: Pure static file serving only

### ⚠️ Known Limitations

As a lightweight development server, Pilipili Server has these limitations:

- **Not recommended for production**: Use proper web servers (nginx, Apache) for production
- **No HTTPS**: No SSL/TLS support built-in
- **No Authentication**: No user authentication or access control
- **Basic HTTP**: Limited HTTP features compared to full web servers
- **Local Use**: Best suited for local development and file sharing

### 🔒 Security Best Practices

When using Pilipili Server:

1. **Local Development Only**: Don't expose to public internet
2. **Firewall Protection**: Use firewall rules to limit access
3. **Trusted Networks**: Only use on trusted local networks
4. **File Permissions**: Set appropriate file permissions
5. **Regular Updates**: Keep your system and dependencies updated

### 📋 Vulnerability Categories

We consider these as security issues:

- **Path Traversal**: Accessing files outside serve directory
- **Code Injection**: Any form of script injection
- **DoS Attacks**: Resource exhaustion vulnerabilities
- **Information Disclosure**: Leaking sensitive information

### 🏆 Security Credits

We appreciate security researchers who help improve Pilipili Server:

- [Your name could be here!]

---

**Remember**: Pilipili Server is designed for development and learning. For production use, please use enterprise-grade web servers.
