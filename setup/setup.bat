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
choco -y install wget SublimeText3 Cygwin cmder 



