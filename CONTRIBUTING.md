# Contributing

To get started, please follow the steps outlined below.

## Build

Before you begin contributing, make sure to build the module. This step is crucial for setting up the necessary environment for development.

Use the following command:

```powershell
./build.ps1
```

The `build.ps1` script automates several tasks to prepare the development environment. It requires PowerShell version 7.0 or higher and the Microsoft.Powershell.Crescendo module.

The script performs the following actions:

- Retrieves configuration manifests from the "commands" directory.
- Initializes handler functions from the "handlers" directory, such as `Output.ps1`.
- Initializes transform functions from the "transforms" directory, such as `Argument.ps1`.
- Generates the module source using `Export-CrescendoModule` based on the retrieved configuration manifests.
- Updates the module manifest (`Radius.psd1`) with specified parameters, such as version, author, and powershell version.
- Imports the generated Radius module.

After running the `build.ps1` script, you can verify that the module is successfully imported using the following commands:

```powershell
Get-Command -Module Radius
Get-Module -Name Radius
```

Expected output:

```
ModuleType  Version  PreRelease  Name    ExportedCommands
----------  -------  ----------  ----    ----------------
Script      0.0.1                Radius  {Debug-Radius, Get-RadiusApplication, Get-RadiusApplicationConnections, Get-RadiusApplicationDetail…}
```

To validate the module commands are working correctly, use the following command:

```powershell
Get-RadiusVersion
```

Expected output:

```
release version bicep  commit
------- ------- -----  ------
0.29.0  v0.29.0 0.29.0 6abd7bfc3de0e748a2c34b721d95097afb6a2bba
```

This output confirms that the `rad` tool is successfully installed and the PowerShell shim is communicate with it.

## Test

To ensure the reliability of your changes and the overall functionality of the module, it's crucial to run the provided tests using the `test.ps1` script. Before running the tests, ensure you have PowerShell version 7.0 or higher installed, as well as the Pester module.

Execute the following command to run the tests:

```powershell
./test.ps1
```

The `test.ps1` script is designed to validate the correct behavior of the module. It performs various tests located in the "test" directory to assess the functionality of different components.

By running the test script, you can verify that the module functions as expected and identify any potential issues or bugs introduced by your changes. Please ensure that all tests pass before submitting your contribution.
