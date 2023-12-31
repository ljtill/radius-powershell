# Radius PowerShell

## Commands

| Area           | Original Command                | Command                          |
| -------------- | ------------------------------- | ---------------------------------|
| Application    | rad application list            | Get-RadiusApplication            |
| Application    | rad application show            | Get-RadiusApplicationDetail      |
| Application    | rad application connections     | Get-RadiusApplicationConnections |
| Application    | rad application status          | Get-RadiusApplicationStatus      |
| Application    | rad application delete          | Remove-RadiusApplication         |
| Application    | rad application switch          | Switch-RadiusApplication         |
| ---            | ---                             | ---                              |
| Bicep          | rad bicep download              | Install-RadiusBicep              |
| Bicep          | rad bicep delete                | Uninstall-RadiusBicep            |
| Bicep          | rad bicep publish               | Publish-RadiusBicep              |
| ---            | ---                             | ---                              |
| Credential     | rad credential list             | Get-RadiusCredential             |
| Credential     | rad credential show             | Get-RadiusCredentialDetail       |
| Credential     | rad credential register azure   | Register-RadiusCredential        |
| Credential     | rad credential unregister azure | Unregister-RadiusCredential      |
| ---            | ---                             | ---                              |
| Debug Logs     | rad debug-logs                  | Debug-Radius                     |
| ---            | ---                             | ---                              |
| Deployment     | rad deploy                      | New-RadiusDeployment             |
| ---            | ---                             | ---                              |
| Environment    | rad env list                    | Get-RadiusEnvironment            |
| Environment    | rad env show                    | Get-RadiusEnvironmentDetail      |
| Environment    | rad env create                  | New-RadiusEnvironment            |
| Environment    | rad env delete                  | Remove-RadiusEnvironment         |
| Environment    | rad env switch                  | Switch-RadiusEnvironment         |
| Environment    | rad env set                     | Update-RadiusEnvironment         |
| ---            | ---                             | ---                              |
| Resource Group | rad group list                  | Get-RadiusGroup                  |
| Resource Group | rad group show                  | Get-RadiusGroupDetail            |
| Resource Group | rad group create                | New-RadiusGroup                  |
| Resource Group | rad group delete                | Remove-RadiusGroup               |
| Resource Group | rad group switch                | Switch-RadiusGroup               |
| ---            | ---                             | ---                              |
| Initialize     | rad init                        | Initialize-Radius                |
| ---            | ---                             | ---                              |
| Install        | rad install kubernetes          | Install-Radius                   |
| Uninstall      | rad uninstall kubernetes        | Uninstall-Radius                 |
| ---            | ---                             | ---                              |
| Recipe         | rad recipe list                 | Get-RadiusRecipe                 |
| Recipe         | rad recipe show                 | Get-RadiusRecipeDetail           |
| Recipe         | rad recipe register             | Register-RadiusRecipe            |
| Recipe         | rad recipe unregister           | Unregister-RadiusRecipe          |
| ---            | ---                             | ---                              |
| Resource       | rad resource list               | Get-RadiusResource               |
| Resource       | rad resource show               | Get-RadiusResourceDetail         |
| Resource       | rad resource delete             | Remove-RadiusResource            |
| Resource       | rad resource logs               | Get-RadiusResourceLogs           |
| ---            | ---                             | ---                              |
| Run            | rad run                         | Invoke-Radius                    |
| ---            | ---                             | ---                              |
| Version        | rad version                     | Get-RadiusVersion                |
| ---            | ---                             | ---                              |
| Workspace      | rad workspace list              | Get-RadiusWorkspace              |
| Workspace      | rad workspace show              | Get-RadiusWorkspaceDetail        |
| Workspace      | rad workspace create            | New-RadiusWorkspace              |
| Workspace      | rad workspace delete            | Remove-RadiusWorkspace           |
| Workspace      | rad workspace switch            | Switch-RadiusWorkspace           |
