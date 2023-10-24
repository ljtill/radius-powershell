#requires -Version 7.0
#requires -Modules Microsoft.PowerShell.Crescendo

$rootPath = (Get-Item $PSScriptRoot)

Push-Location -Path $rootPath/src

Write-Verbose -Message "Retrieving configuration manifests..."
$commands = (Get-ChildItem "./commands" | Select-Object -ExpandProperty FullName)

Write-Verbose -Message "Initializing handler functions..."
. ./handlers/Parser.ps1

$Params = @{
    Path              = "./Radius.psd1"
    RootModule        = "Radius.psm1"
    ModuleVersion     = "0.0.1"
    Guid              = "2f010876-a659-4995-b5bf-8378e4e7ce34"
    Author            = "Lyon Till"
    CompanyName       = "."
    Copyright         = "(c) Lyon Till. All rights reserved."
    PowerShellVersion = "7.2.0"
}

Write-Verbose -Message "Generating Radius module..."
Export-CrescendoModule -ConfigurationFile $commands -ModuleName "./Radius.psm1" -Force

Write-Verbose -Message "Updating module manifest..."
Update-ModuleManifest @Params

Pop-Location
