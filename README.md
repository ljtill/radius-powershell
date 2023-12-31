# Radius PowerShell

This repository contains a PowerShell module designed to serve as a wrapper for the "rad" tool, offering a collection of PowerShell cmdlets tailored for interaction with Radius, the cloud-native application platform. Leveraging the Crescendo framework, this module simplifies the integration process, enabling developers and platform engineers to efficiently harness the power of Radius within the PowerShell ecosystem. These cmdlets streamline the development and management of cloud-native applications, ensuring best practices for cost, operations, and security in the Radius environment.

_Please note these artifacts are under development and subject to change._

---

**Getting Started**

Prior to utilizing this module, it is necessary to have the Radius CLI installed on your local system.

```powershell
Import-Module "./src/Radius.psd1" -Force
Get-Command -Module "Radius"
```

The module has not yet been published on the PowerShell Gallery, so you'll need to import it manually for use.

---

- [Website](https://radapp.io/)
- [Documentation](https://docs.radapp.io/)
- [Source](https://github.com/radius-project/radius)
- [Samples](https://github.com/radius-project/samples)
- [Recipes](https://github.com/radius-project/recipes)
- [Commands](https://github.com/ljtill/radius-powershell/blob/main/src/README.md)
