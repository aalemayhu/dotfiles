# Windows Setup Scripts

This directory contains Windows-specific setup scripts and configuration files for the dotfiles project.

## Quick Start

Choose the method that best fits your needs:

### 🚀 Method 1: Manual Setup (Recommended for beginners)
**No Ruby or admin privileges required**
```cmd
windows\setup-manual.bat
```
- Copies configuration files only
- Works immediately without dependencies
- Perfect for trying out the dotfiles

### 🔧 Method 2: PowerShell Setup (Recommended for developers)
**Requires administrator privileges**
```powershell
windows\setup-windows.ps1
```
- Automatically installs Chocolatey and Ruby
- Runs the full dotfiles setup
- Best for complete development environment

### 📦 Method 3: Command Prompt Setup
**Requires administrator privileges**
```cmd
windows\setup-windows.bat
```
- Command Prompt version of the full setup
- Alternative to PowerShell method

### ⚙️ Method 4: Dependencies Only
**Requires administrator privileges**
```cmd
windows\install-choco-ruby.bat
```
- Only installs Chocolatey and Ruby
- Run this first, then use `ruby bin/run.rb`

## Files in this Directory

- `setup-manual.bat` - Manual configuration copy (no dependencies)
- `setup-windows.ps1` - Full PowerShell setup with auto-install
- `setup-windows.bat` - Full Command Prompt setup
- `install-choco-ruby.bat` - Dependencies installer only
- `windows.txt` - List of Windows packages to install via Chocolatey
- `README.md` - This file

## What Gets Installed

The full setup methods install these essential development tools via Chocolatey:

- Git (if not already installed)
- Ruby (for running the dotfiles scripts)
- Make, Vim, Curl, Wget
- 7zip, VS Code, Node.js, Python
- Command-line tools: jq, grep, sed, awk

## After Setup

1. **Restart Git Bash** or your terminal
2. **Test your aliases**: Try `git st`, `ga`, `gs`
3. **Enjoy your configured environment!**

Your shell aliases and Git configuration will work seamlessly in Git Bash, providing a consistent development experience across all platforms.
