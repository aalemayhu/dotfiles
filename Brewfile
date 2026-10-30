# Everything Homebrew installs: `brew bundle` installs it, `make dump` refreshes
# this file from the current machine. Runtimes and npm CLIs are in mise/config.toml.

# Bourne-Again SHell, a UNIX command interpreter
brew "bash"
# Clone of cat(1) with syntax highlighting and Git integration
brew "bat"
# GNU File, Shell, and Text utilities
brew "coreutils"
# Command-line tool for DigitalOcean
brew "doctl"
# Modern, maintained replacement for ls
brew "eza"
# Simple, fast and user-friendly alternative to find
brew "fd"
# Play, record, convert, and stream select audio and video codecs
brew "ffmpeg"
# Command-line fuzzy finder written in Go
brew "fzf"
# GitHub command-line tool
brew "gh"
# Distributed revision control system
brew "git"
# GNU implementation of the famous stream editor
brew "gnu-sed"
# CLI email client written in Rust
brew "himalaya"
# Improved top (interactive process viewer)
brew "htop"
# Lightweight and flexible command-line JSON processor
brew "jq"
# Simple terminal UI for git commands
brew "lazygit"
# Publisher CLI tool for the Official Model Context Protocol (MCP) Registry
brew "mcp-publisher"
# Polyglot runtime manager (asdf rust clone)
brew "mise"
# NCurses Disk Usage
brew "ncdu"
# PDF rendering library (based on the xpdf-3.0 code base)
brew "poppler"
# Object-relational database system
brew "postgresql@16", restart_service: :changed, link: true
# Object-relational database system
brew "postgresql@17", restart_service: :changed
# Search tool like grep and The Silver Searcher
brew "ripgrep"
# Launcher to analyze a project with SonarQube
brew "sonar-scanner"
# Cross-shell prompt for astronauts
brew "starship"
# Display directories as trees (with optional color/HTML output)
brew "tree"
# Parser generator tool
brew "tree-sitter-cli"
# Extremely fast Python package installer and resolver, written in Rust
brew "uv"
# Executes a program periodically, showing output fullscreen
brew "watch"
# Internet file retriever
brew "wget"
# Process YAML, JSON, XML, CSV and properties documents from the CLI
brew "yq"
# Feature-rich command-line audio/video downloader
brew "yt-dlp"
# Pluggable terminal workspace, with terminal multiplexer as the base feature
brew "zellij"
# Shell extension to navigate your filesystem faster
brew "zoxide"
uv "graphifyy"
uv "nwave-ai"

# macOS only: Xcode tooling, GUI apps
if OS.mac?
  tap "facebook/fb"
  # Dependency manager for Cocoa projects
  brew "cocoapods"
  # Easiest way to build and release mobile apps
  brew "fastlane"
  # Library to communicate with iOS devices natively
  brew "libimobiledevice"
  # Generate your Xcode project from a spec file and your folder structure
  brew "xcodegen"
  # Companion server for automating iOS Simulators
  brew "facebook/fb/idb-companion", trusted: true
  # Desktop password manager
  cask "bitwarden"
  cask "font-jetbrains-mono-nerd-font"
  # Terminal emulator that uses platform-native UI and GPU acceleration
  cask "ghostty"
  # Utility to hide menu bar items
  cask "hiddenbar"
  # Control your tools with a few keystrokes
  cask "raycast"
  # Move and resize windows using keyboard shortcuts or snap areas
  cask "rectangle"
  # Team communication and collaboration software
  cask "slack"
  # Native desktop client for WhatsApp
  cask "whatsapp"
end
