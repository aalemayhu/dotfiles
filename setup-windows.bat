@echo off
REM Windows setup script for dotfiles
REM Run this in an Administrator Command Prompt or PowerShell

echo Setting up dotfiles on Windows...

REM Check if Ruby is installed
ruby --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Ruby is not installed. Please install Ruby first from https://rubyinstaller.org/
    echo Or run: choco install ruby
    pause
    exit /b 1
)

REM Check if Git is installed
git --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Git is not installed. Please install Git first from https://git-scm.com/
    echo Or run: choco install git
    pause
    exit /b 1
)

REM Run the Ruby setup script
echo Running dotfiles setup...
ruby bin\run.rb

echo Setup complete!
echo.
echo To use your aliases and Git config:
echo 1. Open Git Bash (recommended)
echo 2. Or add the following to your PowerShell profile:
echo    Add-Content $PROFILE "& '$HOME\.bashrc'"
echo.
pause
