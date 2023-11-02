Describe 'Testing functions' {
    BeforeAll {
        # Module
        $rootPath = (Get-Item $PSScriptRoot).parent
        Import-Module "$rootPath/src/Radius.psd1" -Force

        # Kubernetes
        Invoke-Expression -Command "kind create cluster -n radius -q"
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create cluster"
        }

        # Configuration
        $metadata = @{
            Name = "tests"
        }

        # Radius
        $commands = {
            rad install kubernetes
            rad group create $metadata.Name
            rad env create $metadata.Name -g $metadata.Name
            rad workspace create kubernetes $metadata.Name -g $metadata.Name -e $metadata.Name
            rad recipe register default -e $metadata.Name -w $metadata.Name --template-kind bicep --template-path ghcr.io/radius-project/recipes/local-dev/mongodatabases:latest --resource-type Applications.Datastores/mongoDatabases
            rad deploy ./test/templates/main.bicep -g $metadata.Name -e $metadata.Name
        }

        Invoke-Expression -Command $commands.ToString()
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create resources"
        }
    }
    AfterAll {
        # Radius
        $commands = {
            rad app delete $metadata.Name -g $metadata.Name --yes
            rad env delete $metadata.Name -g $metadata.Name --yes
            rad group delete $metadata.Name --yes
            rad workspace delete $metadata.Name --yes
            rad uninstall kubernetes
        }

        Invoke-Expression -Command $commands.ToString()
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to delete resources"
        }

        # Kubernetes
        Invoke-Expression -Command "kind delete cluster -n radius -q"
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to delete cluster"
        }
    }

    Context 'Version' {
        Describe 'Get-RadiusVersion' {
            It 'Returns version' {
                $version = Get-RadiusVersion
                $version | Should -Not -BeNullOrEmpty
            }
        }
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
                $workspace = Get-RadiusWorkspaceDetail -Name $metadata.Name
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
        Describe 'New-RadiusGroup' {
            It 'Creates resource groups' {
                { New-RadiusGroup -Name 'group-1' -Workspace $metadata.Name } | Should -Not -Throw
                { New-RadiusGroup -Name 'group-2' -Workspace $metadata.Name } | Should -Not -Throw
            }
        }
        Describe 'Get-RadiusGroup' {
            It 'Returns resource groups' {
                $groups = Get-RadiusGroup -Workspace $metadata.Name
                $groups | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusGroupDetail' {
            It 'Returns resource group' {
                $group = Get-RadiusGroupDetail -Name $metadata.Name -Workspace $metadata.Name
                $group | Should -Not -BeNullOrEmpty
                $group.id | Should -Be "/planes/radius/local/resourcegroups/$($metadata.Name)"
                $group.location | Should -Be "global"
                $group.name | Should -Be $metadata.Name
                $group.type | Should -Be "System.Resources/resourceGroups"
            }
        }
        Describe 'Switch-RadiusGroup' {
            It 'Switches resource group' {
                { Switch-RadiusGroup -Name 'group-2' -Workspace $metadata.Name } | Should -Not -Throw
                { Switch-RadiusGroup -Name 'group-1' -Workspace $metadata.Name } | Should -Not -Throw
            }
        }
        Describe 'Remove-RadiusGroup' {
            It 'Deletes resource groups' {
                { Remove-RadiusGroup -Name 'group-1' -Workspace $metadata.Name -Force } | Should -Not -Throw
                { Remove-RadiusGroup -Name 'group-2' -Workspace $metadata.Name -Force } | Should -Not -Throw
            }
        }
    }

    Context 'Environment' {
        Describe 'New-RadiusEnvironment' {
            It 'Creates environments' {
                { New-RadiusEnvironment -Name "environment-1" -Group $metadata.Name -Workspace $metadata.Name } | SHould -Not -Throw
                { New-RadiusEnvironment -Name "environment-2" -Group $metadata.Name -Workspace $metadata.Name } | SHould -Not -Throw
            }
        }
        Describe 'Get-RadiusEnvironment' {
            It 'Returns environments' {
                $environments = Get-RadiusEnvironment -Group $metadata.Name -Workspace $metadata.Name
                $environments | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusEnvironmentDetail' {
            It 'Returns environment' {
                $environment = Get-RadiusEnvironmentDetail -Name $metadata.Name -Group $metadata.Name -Workspace $metadata.Name
                $environment | Should -Not -BeNullOrEmpty
                $environment.id | Should -Be "/planes/radius/local/resourcegroups/$($metadata.Name)/providers/Applications.Core/environments/$($metadata.Name)"
                $environment.location | Should -Be "global"
                $environment.name | Should -Be $metadata.Name
                $environment.properties.compute.kind | Should -Be "Kubernetes"
                $environment.properties.compute.namespace | Should -Be $metadata.Name
                $environment.type | Should -Be "Applications.Core/environments"
            }
        }
        Describe 'Switch-RadiusEnvironment' {
            It 'Switches environment' {
                # BUG: Exception: '' is not a valid resource id
                # { Switch-RadiusEnvironment -Name $environmentId -Workspace $metadata.Name } | Should -Not -Throw
            }
            It 'Switches environment' {
                # BUG: Exception: '' is not a valid resource id
                # { Switch-RadiusEnvironment -Name $environmentId -Workspace $metadata.Name } | Should -Not -Throw
            }
        }
        Describe 'Update-RadiusEnvironment' {
            It 'Clears providers' {
                { Update-RadiusEnvironment -Name "environment-1" -Group $metadata.Name -ClearAWS } | Should -Not -Throw
            }
            It 'Clears providers' {
                { Update-RadiusEnvironment -Name "environment-1" -Group $metadata.Name -ClearAzure } | Should -Not -Throw
            }
        }
        Describe 'Remove-RadiusEnvironment' {
            It 'Deletes environments' {
                { Remove-RadiusEnvironment -Name "environment-1" -Group $metadata.Name -Workspace $metadata.Name -Force } | Should -Not -Throw
                { Remove-RadiusEnvironment -Name "environment-2" -Group $metadata.Name -Workspace $metadata.Name -Force } | Should -Not -Throw
            }
        }
    }

    Context 'Recipe' {
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

    Context 'Resource' {
        Describe 'Get-RadiusResource' {
            It 'Returns resources' {
                $resources = Get-RadiusResource -Type "Containers" -Group $metadata.Name -Workspace $metadata.Name
                $resources | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusResourceDetail' {
            It 'Returns resource' {
                $resource = Get-RadiusResourceDetail -Type "Containers" -Name $metadata.Name -Group $metadata.Name -Workspace $metadata.Name
                $resource | Should -Not -BeNullOrEmpty
                $resource.location | Should -Be "global"
                $resource.name | Should -Be $metadata.Name
                $resource.type | Should -Be "Applications.Core/containers"
            }
        }
        Describe 'Get-RadiusResourceLogs' {
            # TOOD: Implement
        }
        Describe 'Remove-RadiusResource' {
            # TODO: Implement
        }
    }

    Context 'Application' {
        Describe 'Get-RadiusApplication' {
            It 'Returns applications' {
                $applications = Get-RadiusApplication -Group $metadata.Name -Workspace $metadata.Name
                $applications | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Get-RadiusApplicationDetail' {
            It 'Returns application' {
                $application = Get-RadiusApplicationDetail -Name $metadata.Name -Group $metadata.Name -Workspace $metadata.Name
                $application | Should -Not -BeNullOrEmpty
                $application.location | Should -Be "global"
                $application.name | Should -Be $metadata.Name
                $application.type | Should -Be "Applications.Core/applications"
            }
        }
        Describe 'Get-RadiusApplicationConnections' {
            It 'Returns connections' {
                $connections = Get-RadiusApplicationConnections -Name $metadata.Name -Environment $metadata.Name -Group $metadata.Name -Workspace $metadata.Name
                $connections | Should -Not -BeNullOrEmpty
            }
            It 'Returns connection' {
                # BUG: Returns text data
            }
        }
        Describe 'Get-RadiusApplicationStatus' {
            It 'Returns status' {
                $status = Get-RadiusApplicationStatus -Name $metadata.Name -Group $metadata.Name -Workspace $metadata.Name
                $status | Should -Not -BeNullOrEmpty
            }
        }
        Describe 'Switch-RadiusApplication' {
            # BUG: Exception: '' is not a valid resource id
            # { Switch-RadiusApplication -Name $metadata.Name -Workspace $metadata.Name } | Should -Not -Throw
        }
        Describe 'Remove-RadiusApplication' {
            # TODO: Implement
        }
    }

    Context 'Credential' {
        Describe 'Get-RadiusCredential' {
            # TODO: Implement
        }
        Describe 'Get-RadiusCredentialDetail' {
            # TODO: Implement
        }
        Describe 'Register-RadiusCredential' {
            # TODO: Implment
        }
        Describe 'Unregister-RadiusCredential' {
            # TODO: Implement
        }
    }

    Context 'Deploy' {
        Describe 'New-RadiusDeployment' {
            # TODO: Implement
        }
    }

    Context 'Runtime' {
        BeforeAll {
            Invoke-Expression -Command "rad uninstall kubernetes"
        }
        Describe 'Install-Radius' {
            It 'Installs Radius' {
                { Install-Radius -Platform "Kubernetes" } | Should -Not -Throw
            }
        }
        Describe 'Uninstall-Radius' {
            It 'Installs Radius' {
                { Uninstall-Radius -Platform "Kubernetes" } | Should -Not -Throw
            }
        }
    }
}
