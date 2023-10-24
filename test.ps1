#requires -Version 7.0

$rootPath = (Get-Item $PSScriptRoot)

Push-Location -Path $rootPath/src

Write-Verbose -Message "Importing Radius module..."
Import-Module "./Radius.psd1" -Force

Get-Module -ListAvailable | Format-Table
Get-Command -Module "Radius"

Pop-Location
