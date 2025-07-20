# Windows PowerShell setup script for dotfiles
# Run this in an Administrator PowerShell

Write-Host "Setting up dotfiles on Windows..." -ForegroundColor Green

# Check if Ruby is installed
try {
    ruby --version | Out-Null
} catch {
    Write-Host "Ruby is not installed. Installing via Chocolatey..." -ForegroundColor Yellow
    
    # Install Chocolatey if not present
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    choco install ruby -y
    refreshenv
}

# Check if Git is installed
try {
    git --version | Out-Null
} catch {
    Write-Host "Git is not installed. Installing via Chocolatey..." -ForegroundColor Yellow
    choco install git -y
    refreshenv
}

# Run the Ruby setup script
Write-Host "Running dotfiles setup..." -ForegroundColor Green
ruby bin\run.rb

Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "To use your aliases and Git config:" -ForegroundColor Cyan
Write-Host "1. Open Git Bash (recommended)" -ForegroundColor White
Write-Host "2. Or restart your PowerShell/Command Prompt" -ForegroundColor White
Write-Host "3. Your .bashrc will be loaded automatically in Git Bash" -ForegroundColor White
