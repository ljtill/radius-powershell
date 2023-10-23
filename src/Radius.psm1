# Module created by Microsoft.PowerShell.Crescendo
# Version: 1.1.0
# Schema: https://aka.ms/PowerShell/Crescendo/Schemas/2022-06
# Generated at: 10/23/2023 16:40:15
class PowerShellCustomFunctionAttribute : System.Attribute {
    [bool]$RequiresElevation
    [string]$Source
    PowerShellCustomFunctionAttribute() { $this.RequiresElevation = $false; $this.Source = "Microsoft.PowerShell.Crescendo" }
    PowerShellCustomFunctionAttribute([bool]$rElevation) {
        $this.RequiresElevation = $rElevation
        $this.Source = "Microsoft.PowerShell.Crescendo"
    }
}

# Returns available errors
# Assumes that we are being called from within a script cmdlet when EmitAsError is used.
function Pop-CrescendoNativeError {
param ([switch]$EmitAsError)
    while ($__CrescendoNativeErrorQueue.Count -gt 0) {
        if ($EmitAsError) {
            $msg = $__CrescendoNativeErrorQueue.Dequeue()
            $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
            $PSCmdlet.WriteError($er)
        }
        else {
            $__CrescendoNativeErrorQueue.Dequeue()
        }
    }
}
# this is purposefully a filter rather than a function for streaming errors
filter Push-CrescendoNativeError {
    if ($_ -is [System.Management.Automation.ErrorRecord]) {
        $__CrescendoNativeErrorQueue.Enqueue($_)
    }
    else {
        $_
    }
}

function Get-RadiusApplication
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'application'
    $__commandArgs += 'list'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  ef02d281dcbf3a900b8d625be3637a9d


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusApplication

List Radius Applications
Original Command: rad application list


#>
}


function Get-RadiusApplicationConnections
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'application'
    $__commandArgs += 'connections'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  bf116eca0861c9b635dd2bc738abd706


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusApplicationConnections

Shows the Connections for Radius Application
Original Command: rad application connections


#>
}


function Get-RadiusApplicationStatus
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'application'
    $__commandArgs += 'status'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  cabf360198d765156fc25a535946345c


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusApplicationStatus

Show Radius Application status
Original Command: rad application status


#>
}


function Set-RadiusApplication
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'application'
    $__commandArgs += 'switch'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  496cb53c31acfc060946db7ff586c3d6


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Workspace




.EXAMPLE
PS> Set-RadiusApplication

Switch the default Radius Application
Original Command: rad application switch


#>
}


function Remove-RadiusApplication
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Confirm
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Confirm = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'application'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  76cf7b9215b6b44745057f99182183ee


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Confirm




.EXAMPLE
PS> Remove-RadiusApplication

Delete Radius Application
Original Command: rad application delete


#>
}


function Install-RadiusBicep
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'bicep'
    $__commandArgs += 'download'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  3496b2cf3801ae53deca799d30431d65


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config




.EXAMPLE
PS> Install-RadiusBicep

Download the bicep compiler
Original Command: rad bicep download


#>
}


function Uninstall-RadiusBicep
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'bicep'
    $__commandArgs += 'delete'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  61dd39e424f04be8e8316fcc2a1f484d


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config




.EXAMPLE
PS> Uninstall-RadiusBicep

Delete installed Bicep compiler
Original Command: rad bicep delete


#>
}


function Publish-RadiusBicep
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$File,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Target
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         File = @{
               OriginalName = '--file'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Target = @{
               OriginalName = '--target'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'bicep'
    $__commandArgs += 'publish'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  d3c69416d0510ac1de2a8d316f5e0b61


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER File



.PARAMETER Target




.EXAMPLE
PS> Publish-RadiusBicep

Publish a Bicep file to an OCI registry
Original Command: rad bicep publish


#>
}


function Get-RadiusCredential
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'list'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  f6880064b6e099f31d2a8c81fa75b65d


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusCredential

List configured cloud provider credentials
Original Command: rad credential list


#>
}


function Get-RadiusCredentialAzure
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'show'
    $__commandArgs += 'azure'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  25b0267f108ee6714939a46b1cba1a2b


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusCredential

List configured cloud provider credentials
Original Command: rad credential list


#>
}


function Get-RadiusCredentialAWS
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'show'
    $__commandArgs += 'aws'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  0a09396c846fe63c27c1d8bd6358fb43


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusCredential

List configured cloud provider credentials
Original Command: rad credential list


#>
}


function Register-RadiusCredentialAzure
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$ClientId,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$ClientSecret,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$TenantId,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ClientId = @{
               OriginalName = '--client-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ClientSecret = @{
               OriginalName = '--client-secret'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         TenantId = @{
               OriginalName = '--tenant-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'register'
    $__commandArgs += 'azure'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  16cf711a16c1d5932bb7e80f1af91c98


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER ClientId



.PARAMETER ClientSecret



.PARAMETER TenantId



.PARAMETER Workspace




.EXAMPLE
PS> Register-RadiusCredential

Register(Add or update) cloud provider credential for a Radius installation
Original Command: rad credential register


#>
}


function Register-RadiusCredentialAWS
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$AccessKeyId,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$SecretAccessKey,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         AccessKeyId = @{
               OriginalName = '--access-key-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         SecretAccessKey = @{
               OriginalName = '--secret-access-key'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'register'
    $__commandArgs += 'azure'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  7456a04ae6f5f24f7d3f809099cd986a


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER AccessKeyId



.PARAMETER SecretAccessKey



.PARAMETER Workspace




.EXAMPLE
PS> Register-RadiusCredential

Register(Add or update) cloud provider credential for a Radius installation
Original Command: rad credential register


#>
}


function Unregister-RadiusCredentialAzure
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'unregister'
    $__commandArgs += 'azure'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  f20900d9b0146f30239980c4d8e3a88f


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Unregister-RadiusBicep

Unregisters a configured cloud provider credential from the Radius installation
Original Command: rad crdential unregister


#>
}


function Unregister-RadiusCredentialAWS
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'credential'
    $__commandArgs += 'unregister'
    $__commandArgs += 'aws'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  2a47fcb0df3dd7ab3ecc045aa1713cbf


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Unregister-RadiusBicep

Unregisters a configured cloud provider credential from the Radius installation
Original Command: rad crdential unregister


#>
}


function Debug-Radius
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'debug-logs'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  1e732f9a30a863f34dabae728efd7e1f


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Debug-Radius

Capture logs from Radius control plane for debugging and diagnostics.
Original Command: rad debug-logs


#>
}


function New-RadiusDeployment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string[]]$Parameters,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Parameters = @{
               OriginalName = '--parameters'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'deploy'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  4f0fdce07b1e426ebc985383342ed8ef


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Parameters



.PARAMETER Workspace




.EXAMPLE
PS> New-RadiusDeployment

Deploy Bicep file
Original Command: rad deploy


#>
}


function Get-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'env'
    $__commandArgs += 'list'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  e5e70c4c99aadcec9b47654c1ad37484


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusEnvironment

List environments
Original Command: rad env list


#>
}


function New-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Namespace,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Namespace = @{
               OriginalName = '--namespace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'env'
    $__commandArgs += 'create'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  47de0577cbdfefa1eb03bf72727d3272


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Namespace



.PARAMETER Workspace




.EXAMPLE
PS> New-RadiusEnvironment

Create a new Radius Environment
Original Command: rad env create


#>
}


function Remove-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Confirm
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Confirm = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'env'
    $__commandArgs += 'delete'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  b8078cc4fd2a6886f6e4e7a3f2b5b14c


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Confirm




.EXAMPLE
PS> Remove-RadiusEnvironment

Delete environment
Original Command: rad env delete


#>
}


function Set-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'env'
    $__commandArgs += 'switch'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  5d4a79d5c789fbbde49473b283326395


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Workspace




.EXAMPLE
PS> Set-RadiusEnvironment

Switch the current environment
Original Command: rad env switch


#>
}


function Update-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$AWSAccountId,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$AWSRegion,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$AzureResourceGroup,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$AzureSubscriptionId,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$ClearAWS,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$ClearAzure,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         AWSAccountId = @{
               OriginalName = '--aws-account-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         AWSRegion = @{
               OriginalName = '--aws-region'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         AzureResourceGroup = @{
               OriginalName = '--azure-resource-group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         AzureSubscriptionId = @{
               OriginalName = '--azure-subscription-id'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ClearAWS = @{
               OriginalName = '--clear-aws'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ClearAzure = @{
               OriginalName = '--clear-azure'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'env'
    $__commandArgs += 'update'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  8f7ebae91e5c9d3f5f4aa79a642ba93a


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER AWSAccountId



.PARAMETER AWSRegion



.PARAMETER AzureResourceGroup



.PARAMETER AzureSubscriptionId



.PARAMETER ClearAWS



.PARAMETER ClearAzure



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Update-RadiusEnvironment

Update environment configuration
Original Command: rad env update


#>
}


function Get-RadiusResourceGroup
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'group'
    $__commandArgs += 'list'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  37dbd13a4876cec0630d1bf76cd4a7d3


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusResourceGroup

List resource groups within current/specified workspace
Original Command: rad group list


#>
}


function New-RadiusResourceGroup
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'group'
    $__commandArgs += 'create'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  ae3a522190d58ae72b0f4ff630769f1a


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> New-RadiusResourceGroup

List resource groups within current/specified workspace
Original Command: rad group create


#>
}


function Remove-RadiusResourceGroup
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Confirm
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Confirm = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'group'
    $__commandArgs += 'delete'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  27280f7ea4949238a3e87ef977b75594


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Confirm




.EXAMPLE
PS> Remove-RadiusResourceGroup

Delete a resource group
Original Command: rad group delete


#>
}


function Set-RadiusResourceGroup
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'group'
    $__commandArgs += 'switch'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  4940a10e86af15a089600cb0f957ddde


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Set-RadiusResourceGroup

Switch default resource group scope
Original Command: rad group switch


#>
}


function Initialize-Radius
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Full
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Full = @{
               OriginalName = '--full'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'init'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  ec073bfe589eb276e72494075b083940


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Full




.EXAMPLE
PS> Initialize-Radius

Initialize Radius
Original Command: rad init


#>
}


function Install-RadiusKubernetes
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Chart,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$KubeContext,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Reinstall,
[Parameter()]
[PSDefaultValue(Value="")]
[string[]]$Set
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Chart = @{
               OriginalName = '--chart'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         KubeContext = @{
               OriginalName = '--kubecontext'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Reinstall = @{
               OriginalName = '--reinstall'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Set = @{
               OriginalName = '--set'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'install'
    $__commandArgs += 'kubernetes'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  45b40a7a96edd52f01dffcceedeb8cb1


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Chart



.PARAMETER KubeContext



.PARAMETER Reinstall



.PARAMETER Set




.EXAMPLE
PS> Install-RadiusKubernetes

Installs Radius onto a Kubernetes cluster
Original Command: rad install kubernetes


#>
}


function Get-RadiusRecipe
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'recipe'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  f40946bfaa0791db7686d33573e70966


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusRecipe

List recipes
Original Command: rad recipe list


#>
}


function Register-RadiusRecipe
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string[]]$Parameters,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$ResourceType,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$TemplateKind,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$TemplatePath,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$TemplateVersion,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Parameters = @{
               OriginalName = '--parameters'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ResourceType = @{
               OriginalName = '--resource-type'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         TemplateKind = @{
               OriginalName = '--template-kind'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         TemplatePath = @{
               OriginalName = '--template-path'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         TemplateVersion = @{
               OriginalName = '--template-version'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'recipe'
    $__commandArgs += 'register'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  1a9106a9e521cc1fb43cfe1ebc942ab4


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Parameters



.PARAMETER ResourceType



.PARAMETER TemplateKind



.PARAMETER TemplatePath



.PARAMETER TemplateVersion



.PARAMETER Workspace




.EXAMPLE
PS> Register-RadiusRecipe

Add a recipe to an environment
Original Command: rad recipe register


#>
}


function Unregister-RadiusRecipe
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$ResourceType,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ResourceType = @{
               OriginalName = '--resource-type'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'recipe'
    $__commandArgs += 'unregister'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  6946b329b528161efdd4b73a67257eeb


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Environment



.PARAMETER Group



.PARAMETER ResourceType



.PARAMETER Workspace




.EXAMPLE
PS> Unregister-RadiusRecipe

Unregister a recipe from an environment
Original Command: rad recipe unregister


#>
}


function Get-RadiusResource
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'resource'
    $__commandArgs += 'list'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  9013adcc0aa11e69660082c95b69124c


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusResource

Lists resources
Original Command: rad resource list


#>
}


function Get-RadiusResourceLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Container,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Follow,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Replica,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Container = @{
               OriginalName = '--container'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Follow = @{
               OriginalName = '--follow'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Replica = @{
               OriginalName = '--replica'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'resource'
    $__commandArgs += 'logs'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  2f6968a47a264fe8ad61abce38cb03ac


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Container



.PARAMETER Follow



.PARAMETER Group



.PARAMETER Replica



.PARAMETER Application



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusResourceLogs

Read logs from a running containers resourc
Original Command: rad resource logs


#>
}


function Remove-RadiusResource
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Confirm
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Confirm = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'resource'
    $__commandArgs += 'delete'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  7a0710967c87b1bfb1b1b30e15d2402f


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Confirm




.EXAMPLE
PS> Remove-RadiusResource

Delete a Radius resource
Original Command: rad resource delete


#>
}


function Invoke-Radius
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Application,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string[]]$Parameters,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Application = @{
               OriginalName = '--application'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Parameters = @{
               OriginalName = '--parameters'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'run'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  6f618ecac89a8d8a23cb52afe3dc7f8e


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Application



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Parameters



.PARAMETER Workspace




.EXAMPLE
PS> Invoke-Radius

Run an application specified by a Bicep file
Original Command: rad run


#>
}


function Uninstall-RadiusKubernetes
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$KubeContext
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         KubeContext = @{
               OriginalName = '--kubecontext'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $true; Handler = $null }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'uninstall'
    $__commandArgs += 'kubernetes'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  657a3a4b8bb796690a8a45a459b8a7dc


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER KubeContext




.EXAMPLE
PS> Uninstall-RadiusKubernetes

Uninstalls Radius onto a Kubernetes cluster
Original Command: rad uninstall kubernetes


#>
}


function Get-RadiusVersion
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$CLI
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         CLI = @{
               OriginalName = '--cli'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'version'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  f0ead56255ac57a0d90875ff54a810e2


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER CLI




.EXAMPLE
PS> Get-RadiusVersion

Prints the versions of the rad cli
Original Command: rad version


#>
}


function Get-RadiusWorkspace
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'workspace'
    $__commandArgs += 'list'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  d1ad37f9317c2321a10a075c449b587a


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Get-RadiusWorkspace

List local workspaces
Original Command: rad workspace list


#>
}


function New-RadiusWorkspaceKubernetes
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Context,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Environment,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Force,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Group,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Context = @{
               OriginalName = '--context'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Environment = @{
               OriginalName = '--environment'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Force = @{
               OriginalName = '--force'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Group = @{
               OriginalName = '--group'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'workspace'
    $__commandArgs += 'create'
    $__commandArgs += 'kubernetes'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  ad73459548a46e14a5fca652de54e32d


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Context



.PARAMETER Environment



.PARAMETER Force



.PARAMETER Group



.PARAMETER Workspace




.EXAMPLE
PS> New-RadiusWorkspace

Create a workspace
Original Command: rad workspace create


#>
}


function Remove-RadiusWorkspace
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace,
[Parameter()]
[PSDefaultValue(Value="")]
[boolean]$Confirm
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Confirm = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'boolean'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'workspace'
    $__commandArgs += 'delete'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  39ae4bccdab6f293c92450bba4510b84


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace



.PARAMETER Confirm




.EXAMPLE
PS> Remove-RadiusWorkspace

Delete local workspaces
Original Command: rad workspace delete


#>
}


function Set-RadiusWorkspace
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="")]
[string]$Workspace
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Config = @{
               OriginalName = '--config'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Workspace = @{
               OriginalName = '--workspace'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        Default = @{ StreamOutput = $True; Handler = { $input | ConvertFrom-Json -Depth 25 } }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    $__commandArgs += 'workspace'
    $__commandArgs += 'switch'
    $__commandArgs += '--output'
    $__commandArgs += 'json'
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/usr/local/bin/rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/usr/local/bin/rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/usr/local/bin/rad")) {
          throw "Cannot find executable '/usr/local/bin/rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/usr/local/bin/rad" $__commandArgs
            }
            else {
                & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/usr/local/bin/rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  f78ab23f855a567d6ec0eaa250cd9467


.DESCRIPTION See help for /usr/local/bin/rad

.PARAMETER Config



.PARAMETER Workspace




.EXAMPLE
PS> Set-RadiusWorkspace

Switch current workspace
Original Command: rad workspace switch


#>
}


