#!/usr/bin/env pwsh

$rootPath = (Get-Item $PSScriptRoot).parent

Remove-Item -Path $rootPath/src/Radius.psm1 -ErrorAction SilentlyContinue

$commands = (Get-ChildItem $rootPath/src/commands | Select-Object -ExpandProperty FullName)

Export-CrescendoModule -ConfigurationFile $commands -ModuleName $rootPath/src/Radius.psm1 -NoClobberManifest
