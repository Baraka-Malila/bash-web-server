#!/bin/bash

# Safe GitHub Packages Publishing Script
# This will NOT interfere with your existing npm package

echo "🐙 Publishing to GitHub Packages (separate from npmjs.com)"
echo "=========================================================="

# Backup original package.json
cp package.json package-npmjs.json.bak
echo "✅ Backed up original package.json"

# Use GitHub-specific package.json
cp github-package.json package.json
echo "✅ Switched to GitHub package configuration"

echo
echo "📦 Publishing @baraka-malila/pilipili-server to GitHub Packages..."
echo "   This is DIFFERENT from pilipili-server on npmjs.com"
echo

# Publish to GitHub Packages
npm publish

# Restore original package.json
cp package-npmjs.json.bak package.json
rm package-npmjs.json.bak
echo "✅ Restored original package.json"

echo
echo "🎉 Done! Your package is now available on BOTH:"
echo "   📦 npmjs.com: npm install -g pilipili-server"
echo "   🐙 GitHub: npm install -g @baraka-malila/pilipili-server"
