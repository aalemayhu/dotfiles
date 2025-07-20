![Build Status](https://github.com/aalemayhu/dotfiles/actions/workflows/dockerimage.yml/badge.svg)

This repository contains the ⚙️ configurations files I use on Linux, macOS, and Windows.

Use this at your own risk and don't expect any support from me if you break
your default setup.

## Installing

### Linux and macOS

Assuming you have already installed the essential build tools on your OS. You will need Ruby, git and make to be present.

```sh
git clone https://github.com/scanf/dotfiles ~/src/github.com/scanf/dotfiles
cd ~/src/github.com/scanf/dotfiles
ruby bin/run.rb
```

### Windows

For Windows, you have several options:

#### Option 1: Using Git Bash (Recommended)
1. Install [Git for Windows](https://git-scm.com/download/win) (includes Git Bash)
2. Install [Ruby](https://rubyinstaller.org/) 
3. Open Git Bash and run:

```bash
git clone https://github.com/scanf/dotfiles ~/src/github.com/scanf/dotfiles
cd ~/src/github.com/scanf/dotfiles
make
```

#### Option 2: Using PowerShell (Administrator required)
```powershell
git clone https://github.com/scanf/dotfiles $env:USERPROFILE\src\github.com\scanf\dotfiles
cd $env:USERPROFILE\src\github.com\scanf\dotfiles
.\setup-windows.ps1
```

#### Option 3: Using Command Prompt (Administrator required)
```cmd
git clone https://github.com/scanf/dotfiles %USERPROFILE%\src\github.com\scanf\dotfiles
cd %USERPROFILE%\src\github.com\scanf\dotfiles
setup-windows.bat
```

#### Option 4: Manual Setup (No Ruby required)
If you just want the basic configuration without installing Ruby:
```cmd
git clone https://github.com/scanf/dotfiles %USERPROFILE%\src\github.com\scanf\dotfiles
cd %USERPROFILE%\src\github.com\scanf\dotfiles
setup-manual.bat
```

### What gets installed on Windows

- **Git aliases and configuration**: Your custom Git shortcuts and settings
- **Bash aliases**: All your shell aliases work in Git Bash
- **Shell functions**: Custom functions available in Git Bash
- **Development tools**: Optional installation via Chocolatey

### Using the configuration

After setup, your aliases and Git config will work in:
- **Git Bash** (recommended - full compatibility)
- **Windows Subsystem for Linux (WSL)**
- **PowerShell** (limited compatibility)
- **Command Prompt** (Git commands only)

Enjoy!