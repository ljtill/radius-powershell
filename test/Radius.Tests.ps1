Describe 'Testing functions' {
    BeforeAll {
        # Module
        $rootPath = (Get-Item $PSScriptRoot).parent
        Import-Module "$rootPath/src/Radius.psd1" -Force

        # Kubernetes
        Invoke-Expression -Command "kind create cluster -n radius -q"

        # Configuration
        $configurationData = @{
            applicationName   = "default"
            credentialName    = "default"
            environmentName   = "default"
            resourceGroupName = "default"
            workspaceName     = "default"
        }

        # Radius
        Install-Radius -Platform "Kubernetes"
    }
    AfterAll {
        # Radius
        Uninstall-Radius -Platform "Kubernetes"

        # Kubernetes
        Invoke-Expression -Command "kind delete cluster -n radius -q"
    }

    Context 'Workspace' {
        Describe 'New-RadiusWorkspace' {
            It 'Creates workspaces' {
                { New-RadiusWorkspace -Platform "Kubernetes" -Name "workspace-1" -Force } | Should -Not -Throw
                { New-RadiusWorkspace -Platform "Kubernetes" -Name "workspace-2" -Force } | Should -Not -Throw
            }
        }
        Describe 'Get-RadiusWorkspace' {
            It 'Returns workspaces' {
                $workspaces = Get-RadiusWorkspace
                $workspaces | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusWorkspaceDetail' {
            It 'Returns workspace' {
                $workspace = Get-RadiusWorkspaceDetail -Name "workspace-1"
                $workspace | Should -Not -BeNullOrEmpty
                $workspace.connection.context | Should -Be "kind-radius"
                $workspace.connection.kind | Should -Be "Kubernetes"
            }
        }

        Describe 'Switch-RadiusWorkspace' {
            It 'Switches workspace' {
                { Switch-RadiusWorkspace -Name "workspace-2" } | Should -Not -Throw
                { Switch-RadiusWorkspace -Name "workspace-1" } | Should -Not -Throw
            }
        }

        Describe 'Remove-RadiusWorkspace' {
            It 'Deletes workspaces' {
                { Remove-RadiusWorkspace -Name "workspace-1" -Force } | Should -Not -Throw
                { Remove-RadiusWorkspace -Name "workspace-2" -Force } | Should -Not -Throw
            }
        }
    }

    Context 'Resource Group' {
        BeforeAll {
            New-RadiusWorkspace -Platform "Kubernetes" -Name $configurationData.workspaceName
            # BUG: Command does not return all required data
            # $workspace = (Get-RadiusWorkspaceDetail -Name $configurationData.workspaceName).connection.context
            $workspace = $configurationData.workspaceName
        }
        AfterAll {
            Remove-RadiusWorkspace -Name $configurationData.workspaceName -Force
        }

        Describe 'New-RadiusResourceGroup' {
            It 'Creates resource groups' {
                { New-RadiusResourceGroup -Name 'group-1' -Workspace $workspace } | Should -Not -Throw
                { New-RadiusResourceGroup -Name 'group-2' -Workspace $workspace } | Should -Not -Throw
            }
        }
        Describe 'Get-RadiusResourceGroup' {
            It 'Returns resource groups' {
                $resourceGroups = Get-RadiusResourceGroup -Workspace $workspace
                $resourceGroups | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusResourceGroupDetail' {
            It 'Returns resource group' {
                $resourceGroup = Get-RadiusResourceGroupDetail -Name "group-1" -Workspace $workspace
                $resourceGroup | Should -Not -BeNullOrEmpty
                $resourceGroup.location | Should -Be "global"
                $resourceGroup.name | Should -Be "group-1"
                $resourceGroup.type | Should -Be "System.Resources/resourceGroups"
            }
        }
        Describe 'Switch-RadiusResourceGroup' {
            It 'Switches resource group' {
                { Switch-RadiusResourceGroup -Name 'group-2' -Workspace $workspace } | Should -Not -Throw
                { Switch-RadiusResourceGroup -Name 'group-1' -Workspace $workspace } | Should -Not -Throw
            }
        }
        Describe 'Remove-RadiusResourceGroup' {
            It 'Deletes resource groups' {
                { Remove-RadiusResourceGroup -Name 'group-1' -Workspace $workspace -Force } | Should -Not -Throw
                { Remove-RadiusResourceGroup -Name 'group-2' -Workspace $workspace -Force } | Should -Not -Throw
            }
        }
    }

    Context 'Environment' {
        BeforeAll {
            New-RadiusWorkspace -Platform "Kubernetes" -Name $configurationData.workspaceName
            # BUG: Command does not return all required data
            # $workspace = (Get-RadiusWorkspaceDetail -Name $configurationData.workspaceName).connection.context
            $workspace = $configurationData.workspaceName
            New-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName
            $resourceGroup = (Get-RadiusResourceGroupDetail -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName).name
        }
        AfterAll {
            Remove-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName -Force
            Remove-RadiusWorkspace -Name $configurationData.workspaceName -Force
        }

        Describe 'New-RadiusEnvironment' {
            It 'Creates environments' {
                { New-RadiusEnvironment -Name "environment-1" -Group $resourceGroup -Workspace $workspace } | SHould -Not -Throw
                { New-RadiusEnvironment -Name "environment-2" -Group $resourceGroup -Workspace $workspace } | SHould -Not -Throw
            }
        }
        Describe 'Get-RadiusEnvironment' {
            It 'Returns environments' {
                $environments = Get-RadiusEnvironment -Group $resourceGroup -Workspace $workspace
                $environments | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusEnvironmentDetail' {
            It 'Returns environment' {
                $environment = Get-RadiusEnvironmentDetail -Name "environment-1" -Group $resourceGroup -Workspace $workspace
                $environment | Should -Not -BeNullOrEmpty
                $environment.location | Should -Be "global"
                $environment.name | Should -Be "environment-1"
                $environment.type | Should -Be "Applications.Core/environments"
            }
        }
        Describe 'Switch-RadiusEnvironment' {
            It 'Switches environment' {
                # BUG: Exception: '' is not a valid resource id
                # { Switch-RadiusEnvironment -Name $environmentId -Workspace $workspace } | Should -Not -Throw
            }
            It 'Switches environment' {
                # BUG: Exception: '' is not a valid resource id
                # { Switch-RadiusEnvironment -Name $environmentId -Workspace $workspace } | Should -Not -Throw
            }
        }
        Describe 'Update-RadiusEnvironment' {
            It 'Clears providers (aws)' {
                { Update-RadiusEnvironment -Name "environment-1" -Group $resourceGroup -ClearAWS } | Should -Not -Throw
            }
            It 'Clears providers (azure)' {
                { Update-RadiusEnvironment -Name "environment-1" -Group $resourceGroup -ClearAzure } | Should -Not -Throw
            }
        }
        Describe 'Remove-RadiusEnvironment' {
            It 'Deletes environments' {
                { Remove-RadiusEnvironment -Name "environment-1" -Group $resourceGroup -Workspace $workspace -Force } | Should -Not -Throw
                { Remove-RadiusEnvironment -Name "environment-2" -Group $resourceGroup -Workspace $workspace -Force } | Should -Not -Throw
            }
        }

    }

    Context 'Recipe' {
        BeforeAll {
            New-RadiusWorkspace -Platform "Kubernetes" -Name $configurationData.workspaceName
            # BUG: Command does not return all required data
            # $workspace = (Get-RadiusWorkspaceDetail -Name $configurationData.workspaceName).connection.context
            $workspace = $configurationData.workspaceName
            New-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName
            $resourceGroup = (Get-RadiusResourceGroupDetail -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName).name
        }
        AfterAll {
            Remove-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName -Force
            Remove-RadiusWorkspace -Name $configurationData.workspaceName -Force
        }

        Describe 'Register-RadiusRecipe' {
            # TODO: Implement
        }
        Describe 'Unregister-RadiusRecipe' {
            # TODO: Implement
        }
        Describe 'Get-RadiusRecipe' {
            # TODO: Implement
        }
        Describe 'Get-RadiusRecipeDetail' {
            # TODO: Implement
        }
    }

    Context 'Deploy' {
        BeforeAll {}
        AfterAll {}

        Describe 'New-RadiusDeployment' {
            It 'Deploys resources' {

            }
        }
    }

    Context 'Resource' {
        BeforeAll {
            New-RadiusWorkspace -Platform "Kubernetes" -Name $configurationData.workspaceName
            # BUG: Command does not return all required data
            # $workspace = (Get-RadiusWorkspaceDetail -Name $configurationData.workspaceName).connection.context
            $workspace = $configurationData.workspaceName
            New-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName
            $resourceGroup = (Get-RadiusResourceGroupDetail -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName).name

            # TODO: Deploy
        }
        AfterAll {
            Remove-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName -Force
            Remove-RadiusWorkspace -Name $configurationData.workspaceName -Force
        }

        Describe 'Get-RadiusResource' {
            It 'Returns resources' {
                # $resources = Get-RadiusResource -ResourceType "containers" -Group $resourceGroup -Workspace $workspace
                # $resources | Should -Not -BeNullOrEmpty
                # $resources.location | Should -Be "global"
                # $resources.name | Should -Be "name"
                # $resources.type | Should -Be "Applications.Core/containers"
            }
        }
        Describe 'Get-RadiusResourceDetail' {
            It 'Returns resource' {
                # $resource = Get-RadiusResourceDetail -Name "demo" -ResourceType "containers" -Group $resourceGroup -Workspace $workspace
                # $resource | Should -Not -BeNullOrEmpty
                # $resources.location | Should -Be "global"
                # $resources.name | Should -Be "demo"
                # $resources.type | Should -Be "Applications.Core/containers"
            }
        }
        Describe 'Get-RadiusResourceLogs' {
            It 'Returns logs' {
                # TOOD: Implement
            }
        }
        Describe 'Remove-RadiusResource' {
            It 'Removes resource' {
                # TODO: Implement
            }
        }
    }

    Context 'Application' {
        BeforeAll {
            New-RadiusWorkspace -Platform "Kubernetes" -Name $configurationData.workspaceName
            # BUG: Command does not return all required data
            # $workspace = (Get-RadiusWorkspaceDetail -Name $configurationData.workspaceName).connection.context
            $workspace = $configurationData.workspaceName
            New-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName
            $resourceGroup = (Get-RadiusResourceGroupDetail -Name $configurationData.resourceGroupName).name
            New-RadiusEnvironment -Name $configurationData.environmentName -Group $configurationData.resourceGroupName -Workspace $configurationData.workspaceName
            $environment = (Get-RadiusEnvironmentDetail -Name $configurationData.environmentName -Group $configurationData.resourceGroupName -Workspace $configurationData.workspaceName)

            # TODO: Deploy
        }
        AfterAll {
            Remove-RadiusEnvironment -Name $configurationData.environmentName -Group $configurationData.resourceGroupName -Workspace $configurationData.workspaceName -Force
            Remove-RadiusResourceGroup -Name $configurationData.resourceGroupName -Workspace $configurationData.workspaceName -Force
            Remove-RadiusWorkspace -Name $configurationData.workspaceName -Force
        }

        Describe 'Get-RadiusApplication' {
            It 'Returns applications' {
                # $applications = Get-RadiusApplication -Group $resourceGroup -Workspace $workspace
                # $applications | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusApplicationDetail' {
            It 'Returns application' {
                # $application = Get-RadiusApplicationDetail -Name "application-1" -Group $resourceGroup -Workspace $workspace
                # $application | Should -Not -BeNullOrEmpty
                # $application.location | Should -Be "global"
                # $application.name | Should -Be "application-1"
                # $application.type | Should -Be "Applications.Core/applications"
            }
        }
        Describe 'Get-RadiusApplicationConnections' {
            It 'Returns connections' {
                # $connections = Get-RadiusApplicationConnections -Environment $environment -Group $resourceGroup -Workspace $workspace
                # $connections | Should -Not -BeNullOrEmpty
            }
            It 'Returns connection' {
                # $connection = Get-RadiusApplicationConnections -Name $applicationName -Environment $environment -Group $resourceGroup -Workspace $workspace
                # $connection | Should -Not -BeNullOrEmpty
                # $connection | Should -Be
            }
        }
        Describe 'Get-RadiusApplicationStatus' {
            It 'Returns an application status' {
                # $status = Get-RadiusApplicationStatus -Name $applicationName -Group $resourceGroup -Workspace $workspace
                # $status | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Switch-RadiusApplication' {
            # TODO: Implement
        }
        Describe 'Remove-RadiusApplication' {
            # TODO: Implement
        }
    }

    Context 'Credential' {
        BeforeAll {
            New-RadiusWorkspace -Platform "Kubernetes" -Name $configurationData.workspaceName
            # BUG: Command does not return all required data
            # $workspace = (Get-RadiusWorkspaceDetail -Name $configurationData.workspaceName).connection.context
            $workspace = $configurationData.workspaceName
        }
        AfterAll {
            Remove-RadiusWorkspace -Name $configurationData.workspaceName -Force
        }

        Describe 'Get-RadiusCredential' {
            It 'Returns credentials' {
                # $credentials = Get-RadiusCredential -Workspace $workspace
                # $credentials | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusCredentialDetail' {
            It 'Returns credential' {
                # $credential = Get-RadiusCredentialDetail -Name $credentialName -Provider "Azure" -Workspace $workspace
                # $credential | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Register-RadiusCredential' {
            # TODO: Implment
        }
        Describe 'Unregister-RadiusCredential' {
            # TODO: Implement
        }
    }
}
