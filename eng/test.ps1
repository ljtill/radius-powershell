#!/usr/bin/env pwsh

$rootPath = (Get-Item $PSScriptRoot).parent

Import-Module $rootPath/src/Radius.psd1 -Force

Get-Command -Module Radius
