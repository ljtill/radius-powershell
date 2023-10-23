#requires -Version 7.0
#requires -Modules Microsoft.PowerShell.Crescendo

$rootPath = (Get-Item $PSScriptRoot).parent
$commands = (Get-ChildItem $rootPath/src/commands | Select-Object -ExpandProperty FullName)

$Params = @{
    Path              = "$rootPath/src/Radius.psd1"
    RootModule        = "Radius.psm1"
    ModuleVersion     = "0.0.1"
    Guid              = "2f010876-a659-4995-b5bf-8378e4e7ce34"
    Author            = "Lyon Till"
    CompanyName       = "."
    Copyright         = "(c) Lyon Till. All rights reserved."
    PowerShellVersion = "7.2.0"
}

try {
    Export-CrescendoModule -ConfigurationFile $commands -ModuleName "$rootPath/src/Radius.psm1" -Force
    Update-ModuleManifest @Params
}
catch {
    Write-Information -MessageData "Failed to generate module"
    Write-Error $_.Exception
}
