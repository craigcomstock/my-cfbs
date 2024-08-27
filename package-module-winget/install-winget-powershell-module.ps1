# https://github.com/microsoft/winget-cli
# WinGet.Client needs NuGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Microsoft.WinGet.Client
Import-Module -Name Microsoft.WinGet.Client
