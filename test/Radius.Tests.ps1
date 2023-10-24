$rootPath = (Get-Item $PSScriptRoot).parent
Import-Module "$rootPath/src/Radius.psd1" -Force

Describe 'Testing Radius module' {
    BeforeAll {
        # Kubernetes
        Invoke-Expression -Command "kind create cluster"

        # Configuration
        $applicationName = ""
        $credentialName = ""
        $environmentName = "default"
        $resourceGroupName = "default"
        $workspaceName = ""
    }

    Context 'Installation' {
        Describe 'Install-RadiusKubernetes' {
            It 'Returns configuration' {
                Install-RadiusKubernetes
            }
        }
    }

    Context 'Application' {
        Describe 'Get-RadiusApplication' {
            It 'Returns applications' {
                $applications = Get-RadiusApplication
                $applications | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusApplicationDetail' {
            It 'Returns application' {
                $application = Get-RadiusApplicationDetail -Name $applicationName
                $application | Should -Not -BeNullOrEmpty -ErrorAction Stop
                $application.location | Should -Be "global"
                $application.name | Should -Be $applicationName
                $application.type | Should -Be "Applications.Core/applications"
            }
        }
        Describe 'Get-RadiusApplicationConnections' {
            It 'Returns connections' {
                # TODO: Returns string data
                $connections = Get-RadiusApplicationConnections
                $connections | Should -Not -BeNullOrEmpty
            }
            It 'Returns connection' {
                # TODO: Returns string data
                $connection = Get-RadiusApplicationConnections -Name $applicationName
                $connection | Should -Not -BeNullOrEmpty
                $connection | Should -Be
            }
        }
        Describe 'Get-RadiusApplicationStatus' {
            It 'Returns an application status' {
                $status = Get-RadiusApplicationStatus -Name $applicationName
                $status | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Remove-RadiusApplication' {}
        Describe 'Switch-RadiusApplication' {}
    }

    Context 'Bicep' {
        Describe 'Install-RadiusBicep' {
            It 'Downloads Bicep' {
                Install-RadiusBicep
            }
        }
        Describe 'Uninstall-RadiusBicep' {
            It 'Deletes Bicep' {
                Uninstall-RadiusBicep
            }
        }
        Describe 'Publish-RadiusBicep' {
            # TODO: Implement
        }
    }

    Context 'Credential' {
        Describe 'Get-RadiusCredential' {
            It 'Returns credentials' {
                # TODO: Returns string data
                $credentials = Get-RadiusCredential
                $credentials | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusCredentialDetail' {
            It 'Returns credential' {
                # TODO: Returns string data
                $credential = Get-RadiusCredentialDetail -Name $credentialName
                $credential | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Register-RadiusCredentialAzure' {}
        Describe 'Register-RadiusCredentialAWS' {}
        Describe 'Unregister-RadiusCredentialAzure' {}
        Describe 'Unregister-RadiusCredentialAWS' {}
    }

    Context 'Debug' {
        Describe 'Debug-Radius' {
            It 'Returns an archive file' {
                # TODO: Check for zip file
                Debug-Radius
            }
        }
    }

    Context 'Deployment' {
        Describe 'New-RadiusDeployment' {}
    }

    Context 'Environment' {
        Describe 'Get-RadiusEnvironment' {
            It 'Returns environments' {
                $environments = Get-RadiusEnvironment
                $environments | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusEnvironmentDetail' {
            It 'Returns environment' {
                $environment = Get-RadiusEnvironmentDetail -Name $environmentName
                $environment | Should -Not -BeNullOrEmpty -ErrorAction Stop
                $environment.location | Should -Be "global"
                $environment.name | Should -Be $environmentName
                $environment.type | Should -Be "Applications.Core/environments"
            }
        }
        Describe 'New-RadiusEnvironment' {}
        Describe 'Remove-RadiusEnvironment' {}
        Describe 'Switch-RadiusEnvironment' {}
        Describe 'Update-RadiusEnvironment' {}
    }

    Context 'Resource Group' {
        Describe 'Get-RadiusResourceGroup' {
            It 'Returns resource groups' {
                $resourceGroups = Get-RadiusResourceGroup
                $resourceGroups | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusResourceGroupDetail' {
            It 'Returns resource group' {
                $resourceGroup = Get-RadiusResourceGroupDetail -Name "default"
                $resourceGroup | Should -Not -BeNullOrEmpty
                $resourceGroup.location | Should -Be "global"
                $resourceGroup.name | Should -Be $resourceGroupName
                $resourceGroup.type | Should -Be "Applications.Core/resourceGroups"
            }
        }
        Describe 'New-RadiusResourceGroup' {
            It 'Creates resource group' {
                New-RadiusResourceGroup -Name 'test'
            }
        }
        Describe 'Remove-RadiusResourceGroup' {
            It 'Deletes resource group' {
                # Remove-RadiusResourceGroup -Name 'test'
            }
        }

        Describe 'Switch-RadiusResourceGroup' {
            It 'Switches resource group' {
                # Switch-RadiusResourceGroup -Name 'test'
            }
        }
    }

    Context 'Recipe' {
        Describe 'Get-RadiusRecipe' {
            It 'Returns recipes' {
                $recipes = Get-RadiusRecipe
                $recipes | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusRecipeDetail' {
            It 'Returns recipe' {
                # TODO: Returns invalid data
                $recipe = Get-RadiusRecipeDetail -Name "default" -ResourceType "Applications.Datastores/sqlDatabases"
                $recipe | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Register-RadiusRecipe' {}
        Describe 'Unrsegister-RadiusRecipe' {}
    }

    Context 'Resource' {
        Describe 'Get-RadiusResource' {
            It 'Returns resources' {
                $resources = Get-RadiusResource -ResourceType "containers"
                $resources | Should -Not -BeNullOrEmpty
                $resources.location | Should -Be "global"
                $resources.name | Should -Be "name"
                $resources.type | Should -Be "Applications.Core/containers"
            }
        }
        Describe 'Get-RadiusResourceDetail' {
            It 'Returns resource' {
                $resource = Get-RadiusResourceDetail -Name "demo" -ResourceType "containers"
                $resource | Should -Not -BeNullOrEmpty
                $resources.location | Should -Be "global"
                $resources.name | Should -Be "demo"
                $resources.type | Should -Be "Applications.Core/containers"
            }
        }
        Describe 'Remove-RadiusResource' {}
        Describe 'Get-RadiusResourceLogs' {}
    }

    Context 'Run' {
        Describe 'Invoke-Radius' {}
    }

    Context 'Version' {
        Describe 'Get-RadiusVersion' {
            It 'Returns' {
                $version = Get-RadiusVersion
                $version.release | Should -Be 0.26.7
            }
        }
    }

    Context 'Workspace' {
        Describe 'Get-RadiusWorkspace' {
            It 'Returns workspaces' {
                $workspaces = Get-RadiusWorkspace
                $workspaces | Should -Not -BeNullOrEmpty
                $workspaces.location | Should -Be "global"
                $workspaces.name | Should -Be "demo"
                $workspaces.type | Should -Be "Applications.Core/containers"
            }
        }
        Describe 'Get-RadiusWorkspaceDetail' {
            It 'Returns workspaces' {
                $workspace = Get-RadiusWorkspaceDetail -Name $workspaceName
                $workspace | Should -Not -BeNullOrEmpty
                $workspace.connection.context | Should -Be "kind-kind"
                $workspace.connection.kind | Should -Be "kubernetes"
                $workspace.environment | Should -Be "global"
                $workspace.scope | Should -Be "default"
            }
        }
        Describe 'New-RadiusWorkspaceKubernetes' {
            It 'Creates workspace' {
                New-RadiusWorkspaceKubernetes -Name "test"
            }
        }
        Describe 'Remove-RadiusWorkspace' {
            It 'Deletes workspace' {
                Remove-RadiusWorkspace -Name "test"
            }
        }
        Describe 'Switch-RadiusWorkspace' {}
    }

    Context 'Uninstallation' {
        Describe 'Uninstall-RadiusKubernetes' {
            It 'Remoes configuration' {
                Uninstall-RadiusKubernetes
            }
        }
    }

    AfterAll {
        # Kubernetes
        Invoke-Expression -Command "kind delete cluster"
    }
}
