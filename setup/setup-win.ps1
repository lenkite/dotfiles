#Requires -RunAsAdministrator

Write-Output "Running Windows Setup for dotfiles"
Write-Output "Script root is $PSScriptRoot"
$dotfilesDir = "${PSScriptRoot}\.."
function Stop-CygProcesses {
	echo  "Attempting to kill bash/zsh/ConEmu/vim/Cygwin processes.."
	taskkill /f /FI "IMAGENAME eq bash*"
	taskkill /f /FI "IMAGENAME eq zsh*"
	taskkill /f /FI "IMAGENAME eq ConEmu*"
	taskkill /f /FI "IMAGENAME eq vim*"
	taskkill /f /FI "IMAGENAME eq mingw*"
	taskkill /f /FI "IMAGENAME eq Cygwin*"
	taskkill /f /FI "IMAGENAME eq MSYS2*"
}

function Install-MyPackages {
	echo "Installing packages. Ensure that chocolatey (https://chocolatey.org/) is installed!"
	choco install -y vim SublimeText3 Cygwin cmdermini VisualStudioCode autohotkey 7zip
}

function Initialize-MyHardLinks {
	$profileInDotFiles = "$dotfilesDir\PowerShell_profile.ps1"
	Remove-Item $profile
	Write-Output "Creating hard link from $profile to $profileInDotFiles"
	New-Item -ItemType HardLink -Path $profile -Value $profileInDotFiles

	#TODO: In MacOS this is ~/Library/Application\ Support/Code/User
	$vscode_userdir="$HOME\AppData\Roaming\Code\User"
	echo "VS Code user dir: $vscode_userdir"
	if (!(test-path $vscode_userdir)) {
		New-Item -ItemType Directory -Force -Path $vscode_userdir
	}

	$settings="$vscode_userdir\settings.json"
	$settingsTarget="$dotfilesDir\vscode\settings.json"
	$keybindings="$vscode_userdir\keybindings.json"
	$keybindingsTarget="$dotfilesDir\vscode\keybindings.json"

	if (test-path $settings) {
		Remove-Item $settings
	}
	if (test-path $keybindings) {
		Remove-Item $keybindings
  }
	Write-Output "Creating hard link from $settings to $settingsTarget"
	New-Item -ItemType HardLink -Path $settings -Value $settingsTarget 
	Write-Output "Creating hard link from $settings to $settingsTarget"
	New-Item -ItemType HardLink -Path $keybindings -Value $keybindingsTarget

	$vimrcTarget="$dotfilesDir/vimconfig/vimrc"
	$ideavimrcTarget="$dotfilesDir/vimconfig/ideavimrc"
	$gvimrcTarget="$dotfilesDir/vimconfig/gvimrc"

	if (test-path ~/.vimrc) {
		Remove-Item ~/.vimrc
	}
	if (test-path ~/.ideavimrc) {
		Remove-Item ~/.ideavimrc
	}

	if (test-path ~/.gvimrc) {
		Remove-Item ~/.gvimrc
	}
	Write-Output "Creating hard link from ~\.vimrc to $vimrcTarget"
	New-Item -ItemType HardLink -Path ~\.vimrc -Value $vimrcTarget

	Write-Output "Creating hard link from ~\ideavimrc to $ideavimrcTarget"
	New-Item -ItemType HardLink -Path ~\.ideavimrc -Value $ideavimrcTarget
	
	Write-Output "Creating hard link from ~\gvimrc to $gvimrcTarget"
	New-Item -ItemType HardLink -Path ~\.gvimrc -Value $gvimrcTarget
}


# TODO: read C:\tools\cmdermini\config\user-conEmu.xml and remove the -NoProfile 
# Modify Cygwin so that home directory is correct.
$nsswitch_config="C:\tools\cygwin\etc\nsswitch.conf"







