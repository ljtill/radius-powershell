#requires -Version 7.0

$rootPath = (Get-Item $PSScriptRoot).parent

Write-Verbose -Message "Importing Radius module..."
Import-Module "$rootPath/src/Radius.psd1" -Force

Get-Module -ListAvailable | Format-Table
Get-Command -Module "Radius"
