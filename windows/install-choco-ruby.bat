@echo off
REM Windows dependencies installer for dotfiles
REM This script installs Chocolatey and Ruby as administrator

echo Installing Chocolatey package manager...
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

if %ERRORLEVEL% neq 0 (
    echo Failed to install Chocolatey
    pause
    exit /b 1
)

echo Refreshing environment variables...
call refreshenv 2>nul || echo Warning: refreshenv not available yet

echo Installing Ruby via Chocolatey...
choco install ruby -y

if %ERRORLEVEL% neq 0 (
    echo Failed to install Ruby
    pause
    exit /b 1
)

echo Dependencies installed successfully!
echo Please restart your terminal or Git Bash to use Ruby.
pause
