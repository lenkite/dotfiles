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

:install_choco_packages
REM TODO support upgrade if package is alreadyinstalled.
choco install -y wget vim SublimeText3 Cygwin cmdermini VisualStudioCode git autohotkey
REM any other packages

:clone_dotfiles_repo
set git="c:\Program Files\Git\bin\git.exe"
%git% clone https://github.com/lenkite/dotfiles.git %USERPROFILE%\dotfiles

goto :eof REM Make hard links to various files SET vscode_userdir=%USERPROFILE%\AppData\Roaming\Code\User\ mkdir %vscode_userdir% 2>nul REM in case vscode hasn't created dir yet
DEL %vscode_userdir%\settings.json 2>nul
DEL %vscode_userdir%\keybindings.json 2>nul


REM Make hard links to files: vscode settings.json, keybindings.json
REM %USERPROFILE%\AppData\Roaming\Code\User\settings.json to dotfilesdir/vscode/settings.json
REM %USERPROFILE%\AppData\Roaming\Code\User\settings.json to dotfilesdir/vscode/keybindings.json




