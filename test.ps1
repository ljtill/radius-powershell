#requires -Version 7.0

$rootPath = (Get-Item $PSScriptRoot)

Invoke-Pester -Path $rootPath/test -Output Detailed
