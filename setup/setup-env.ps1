#$userPath=[System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$userPath="c:\tools\git\mingw64\bin;C:\Program Files\Python36;$HOME\bin"
[System.Environment]::SetEnvironmentVariable("Path", $userPath, [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable("GOPATH", $HOME, [System.EnvironmentVariableTarget]::User)
