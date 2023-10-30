#requires -Version 7.0

$rootPath = (Get-Item $PSScriptRoot)

Write-Verbose -Message "Starting tests..." -Verbose
Invoke-Pester -Path $rootPath/test -Output Detailed
