@echo off
REM Manual dotfiles setup for Windows (no Ruby required)
echo Setting up dotfiles manually on Windows...

REM Create necessary directories
echo Creating directories...
mkdir "%USERPROFILE%\.shell" 2>nul
mkdir "%USERPROFILE%\.ssh" 2>nul
mkdir "%USERPROFILE%\src\github.com\scanf" 2>nul
mkdir "%USERPROFILE%\src\tmp" 2>nul
mkdir "%USERPROFILE%\.local\bin" 2>nul

REM Copy shell configuration files
echo Copying shell configuration...
if exist "shell\aliases" (
    copy "shell\aliases" "%USERPROFILE%\.shell\.aliases" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy aliases
)
if exist "shell\env" (
    copy "shell\env" "%USERPROFILE%\.shell\.env" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy env
)
if exist "shell\funcs" (
    copy "shell\funcs" "%USERPROFILE%\.shell\.funcs" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy funcs
)
if exist "shell\bashrc" (
    copy "shell\bashrc" "%USERPROFILE%\.bashrc" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy bashrc
)

REM Copy Git configuration
echo Copying Git configuration...
if exist "git\gitconfig" (
    copy "git\gitconfig" "%USERPROFILE%\.gitconfig" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy gitconfig
)
if exist "git\git-completion.bash" (
    copy "git\git-completion.bash" "%USERPROFILE%\.git-completion.bash" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy git-completion.bash
)

REM Copy SSH config if it exists
if exist "ssh\config" (
    echo Copying SSH configuration...
    copy "ssh\config" "%USERPROFILE%\.ssh\config" >nul
    if %ERRORLEVEL% neq 0 echo Warning: Failed to copy SSH config
)

echo.
echo Setup complete!
echo.
echo To use your configuration:
echo 1. Restart Git Bash
echo 2. Your aliases and Git config should now be active
echo.
echo Test with: git st
echo            ga (for git add -p)
echo            gs (for git status -s)
echo.
pause
