@echo off
REM See https://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
goto check_Permissions

:check_Permissions
    echo *** WINDOWS SPECIFIC SETUP FOR DOTFILES ***
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
    ) else (
        echo Failure: Current permissions inadequate. Hit Enter to exit
        pause >nul
        goto :eof
    )

echo Installing packages. Ensure that chocolatey (https://chocolatey.org/) is installed!
REM kill active processes
taskkill /f /FI "IMAGENAME eq bash*"
taskkill /f /FI "IMAGENAME eq zsh*"
taskkill /f /FI "IMAGENAME eq ConEmu*"
taskkill /f /FI "IMAGENAME eq vim*"
taskkill /f /FI "IMAGENAME eq mingw*"
taskkill /f /FI "IMAGENAME eq Cygwin*"
taskkill /f /FI "IMAGENAME eq MSYS2*"

:download_wget
REM mkdir c:\temp 2>nul
echo Downloading wget...
REM https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/PortableGit-2.13.2-64-bit.7z.exe
REM https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/PortableGit-2.13.2-64-bit.7z.exe
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/PortableGit-2.13.2-64-bit.7z.exe', 'c:\temp\git.exe'))" 
set wget='c:\temp\wget.exe'
set git='c:\temp\git.exe'
goto :eof

:install_choco_packages
REM TODO support upgrade if package is alreadyinstalled.
choco install -y SublimeText3 Cygwin cmdermini VisualStudioCode autohotkey 7zip
REM any other packages

:download_dotfiles_repo
set git="c:\Program Files\Git\bin\git.exe"
%git% clone https://github.com/lenkite/dotfiles.git %USERPROFILE%\dotfiles

goto :eof 
REM Make hard links to various files SET vscode_userdir=%USERPROFILE%\AppData\Roaming\Code\User\ mkdir %vscode_userdir% 2>nul REM in case vscode hasn't created dir yet
DEL %vscode_userdir%\settings.json 2>nul
DEL %vscode_userdir%\keybindings.json 2>nul


REM Make hard links to files: vscode settings.json, keybindings.json
REM %USERPROFILE%\AppData\Roaming\Code\User\settings.json to dotfilesdir/vscode/settings.json
REM %USERPROFILE%\AppData\Roaming\Code\User\settings.json to dotfilesdir/vscode/keybindings.json




