#!/bin/bash

# Pilipili Server npm Publishing Guide
# This script helps you publish the package to npm

echo "🌶️ Pilipili Server - npm Publishing Guide"
echo "=========================================="
echo

# Check if npm is installed
if ! command -v npm >/dev/null 2>&1; then
    echo "❌ npm is not installed. Please install Node.js first:"
    echo "   https://nodejs.org/"
    exit 1
fi

echo "✅ npm is available"

# Check if logged in to npm
if ! npm whoami >/dev/null 2>&1; then
    echo "🔑 You need to login to npm first:"
    echo "   npm login"
    echo
    echo "   If you don't have an npm account:"
    echo "   1. Go to https://www.npmjs.com/signup"
    echo "   2. Create an account"
    echo "   3. Run 'npm login'"
    exit 1
fi

echo "✅ Logged in to npm as: $(npm whoami)"

# Validate package.json
if ! npm run test >/dev/null 2>&1; then
    echo "❌ Tests are failing. Please fix tests before publishing."
    exit 1
fi

echo "✅ Tests are passing"

# Check if package name is available
if npm info pilipili-server >/dev/null 2>&1; then
    echo "⚠️  Package 'pilipili-server' already exists on npm."
    echo "   You might need to:"
    echo "   1. Choose a different name (e.g., @your-username/pilipili-server)"
    echo "   2. Or publish as a scoped package"
    exit 1
fi

echo "✅ Package name is available"

echo
echo "🚀 Ready to publish! Run these commands:"
echo
echo "1. Test the package locally:"
echo "   npm pack"
echo "   # This creates a .tgz file you can test"
echo
echo "2. Publish to npm:"
echo "   npm publish"
echo
echo "3. After publishing, test installation:"
echo "   npm install -g pilipili-server"
echo "   pilipili-server --version"
echo
echo "4. Create GitHub release with the same version tag"
echo
echo "📝 Note: Make sure to update version in package.json before publishing updates"
