# From https://blogs.msdn.microsoft.com/virtual_pc_guy/2010/09/23/a-self-elevating-powershell-script/
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
   }
 
# Run your code that needs to be elevated here
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

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
	choco install -y vim golang SublimeText3 cyg-get Cygwin cmdermini VisualStudioCode autohotkey 7zip fzf
	cyg-get install lynx wget curl
}

function Set-MyEnvVars {
	Write-Output "Setting environment variables..."
	$goroot='C:\tools\go'
	if ((Test-Path $goroot)) {
		Write-Output "Setting GOROOT to $goroot"
		[Environment]::SetEnvironmentVariable("GOROOT", $goroot, "Machine")
		Write-Output "Setting GOPATH to $HOME"
		[Environment]::SetEnvironmentVariable("GOPATH", "$HOME", "User")
		$gopath = [Environment]::GetEnvironmentVariable("GOPATH")
		Write-Output "Checking GOPATH = $gopath"
	}
}
function Add-Path([string] $path) {
	# from: https://codingbee.net/tutorials/powershell/powershell-make-a-permanent-change-to-the-path-environment-variable
	# there might be a better way of doing  this
	$oldpath = (Get-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH).path
	Write-Output "Adding $path to PATH"
	$newpath = “$oldpath;c:\path\to\folder”
	Set-ItemProperty -Path ‘Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment’ -Name PATH -Value $newPath
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

function Install-VimPlug {
  if (!(test-path ~/.vim/autoload)) {
    Write-Output "Creating ~/.vim/autoload"
		New-Item -ItemType Directory -Force -Path ~/.vim/autoload
  }
  $plugVimUri="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  Invoke-WebRequest -Uri $plugVimUri -OutFile ~/.vim/autoload/plug.vim
}


# TODO: read C:\tools\cmdermini\config\user-conEmu.xml and remove the -NoProfile 
# Modify Cygwin so that home directory is correct.
$nsswitch_config="C:\tools\cygwin\etc\nsswitch.conf"

#Install-MyPackages
Set-MyEnvVars
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")







