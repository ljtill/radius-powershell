# Module created by Microsoft.PowerShell.Crescendo
# Version: 1.1.0
# Schema: https://aka.ms/PowerShell/Crescendo/Schemas/2022-06
# Generated at: 10/24/2023 22:38:09
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
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  02339b153f3ecd115e018be029c83cb5


.DESCRIPTION See help for rad

.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusApplication

List Radius Applications
Original Command: rad application list


#>
}


function Get-RadiusApplicationDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'show'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  4c12528394e8283da85cf2cc4e2e7cbc


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusApplicationDetail

Show Radius Application details
Original Command: rad application show


#>
}


function Get-RadiusApplicationConnections
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[string]$Name,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  6fb0f0c250e552d325b2b5c599a541b9


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Application



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  4b560c3871e717ca3bf4cd47a696da75


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusApplicationStatus

Show Radius Application status
Original Command: rad application status


#>
}


function Switch-RadiusApplication
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  0de103339f16220bdb72be376b66a213


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Application



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Switch-RadiusApplication

Switch the default Radius Application
Original Command: rad application switch


#>
}


function Remove-RadiusApplication
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[switch]$Yes,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Yes = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  38315becad30e7e6e96e7478e9780629


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Yes



.PARAMETER Config



.PARAMETER Output




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
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  368180b66b06fc88a62f9f0215c1b6ea


.DESCRIPTION See help for rad

.PARAMETER Config



.PARAMETER Output




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
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  c1a006672fe80b05220704c6ab07719d


.DESCRIPTION See help for rad

.PARAMETER Config



.PARAMETER Output




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
[string]$File,
[Parameter()]
[string]$Target,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  82a9cf2e8cfa4fb5cca86c96d8aade6e


.DESCRIPTION See help for rad

.PARAMETER File



.PARAMETER Target



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  aec52bacaaff20e4f52e0707ea626003


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusCredential

List configured cloud provider credentials
Original Command: rad credential list


#>
}


function Get-RadiusCredentialDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  0be8e9b927309f02510d39530c90cb11


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusCredentialDetail

Show details of a configured cloud provider credential
Original Command: rad credential show


#>
}


function Get-RadiusCredentialAzure
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  057b851ee83d4c917b944defde66e7d1


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  8590528a51a4ad0e249c7bdd0bdcbf4a


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$ClientId,
[Parameter()]
[string]$ClientSecret,
[Parameter()]
[string]$TenantId,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  defb85cfd12cb10188aa4109be7a86ae


.DESCRIPTION See help for rad

.PARAMETER ClientId



.PARAMETER ClientSecret



.PARAMETER TenantId



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$AccessKeyId,
[Parameter()]
[string]$SecretAccessKey,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  335463f3537d78fd332527996e23ffe2


.DESCRIPTION See help for rad

.PARAMETER AccessKeyId



.PARAMETER SecretAccessKey



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  2adb46b340c021c1aeef281ebf50391e


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  fb4705fa966fadf4fc4ae9e37829eef4


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  e26146813bd82f4ed3b58ed5d3f19562


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$File,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[array]$Parameters,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         File = @{
               OriginalName = ''
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
               ParameterType = 'array'
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  0ee23ab9f34c78dacdbd942d3e743d30


.DESCRIPTION See help for rad

.PARAMETER File



.PARAMETER Application



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Parameters



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  200219fdcc197570f1d39477ebbd7194


.DESCRIPTION See help for rad

.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusEnvironment

List environments
Original Command: rad env list


#>
}


function Get-RadiusEnvironmentDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'show'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  b01b1f5defde459dba65444997f91bac


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusEnvironmentDetail

Show environment details
Original Command: rad env show


#>
}


function New-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Namespace,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  d330dead203c3e5d20c7476b913387cb


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Namespace



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[switch]$Yes,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Yes = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  1f6e8c1f266e65418260a75765ddeea5


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Yes



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Remove-RadiusEnvironment

Delete environment
Original Command: rad env delete


#>
}


function Switch-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  25a15638d554ad8ed28a18c9a50408fd


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Environment



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Switch-RadiusEnvironment

Switch the current environment
Original Command: rad env switch


#>
}


function Update-RadiusEnvironment
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$AWSAccountId,
[Parameter()]
[string]$AWSRegion,
[Parameter()]
[string]$AzureResourceGroup,
[Parameter()]
[string]$AzureSubscriptionId,
[Parameter()]
[switch]$ClearAWS,
[Parameter()]
[switch]$ClearAzure,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ClearAzure = @{
               OriginalName = '--clear-azure'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  723dfb637510946d2b6018efd7474ea2


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER AWSAccountId



.PARAMETER AWSRegion



.PARAMETER AzureResourceGroup



.PARAMETER AzureSubscriptionId



.PARAMETER ClearAWS



.PARAMETER ClearAzure



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  aae20dd82e7b5db970c6e24180cb1946


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusResourceGroup

List resource groups within current/specified workspace
Original Command: rad group list


#>
}


function Get-RadiusResourceGroupDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'show'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  a7568021592e8207d4910b182a315946


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusResourceGroupDetail

Show the details of a resource group
Original Command: rad group show


#>
}


function New-RadiusResourceGroup
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  d97972e4c08e93ff278fa4eebd6cc16f


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[switch]$Yes,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Yes = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  5f86e9d8f2ba363e4fd0c11054d2087e


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Yes



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Remove-RadiusResourceGroup

Delete a resource group
Original Command: rad group delete


#>
}


function Switch-RadiusResourceGroup
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  38a4ee7b0b973c1a3793eae68bb2c7a1


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Switch-RadiusResourceGroup

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
[switch]$Full,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Full = @{
               OriginalName = '--full'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
    $__commandArgs += 'init'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  5cafc4ce57a3dcfb171e87954cba52c3


.DESCRIPTION See help for rad

.PARAMETER Full



.PARAMETER Config



.PARAMETER Output




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
[string]$Chart,
[Parameter()]
[string]$KubeContext,
[Parameter()]
[string]$Reinstall,
[Parameter()]
[array]$Set,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
               ParameterType = 'array'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  c0036413567503801a515d7e1462573f


.DESCRIPTION See help for rad

.PARAMETER Chart



.PARAMETER KubeContext



.PARAMETER Reinstall



.PARAMETER Set



.PARAMETER Config



.PARAMETER Output




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
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'list'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  a0063cc58b861be9ddf8b8f0ee3325ef


.DESCRIPTION See help for rad

.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusRecipe

List recipes
Original Command: rad recipe list


#>
}


function Get-RadiusRecipeDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$ResourceType,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'show'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  ccd541257096eb9b39c587d903734ebe


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER ResourceType



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusRecipeDetail

Show recipe details
Original Command: rad recipe show


#>
}


function Register-RadiusRecipe
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[array]$Parameters,
[Parameter()]
[string]$ResourceType,
[Parameter()]
[string]$TemplateKind,
[Parameter()]
[string]$TemplatePath,
[Parameter()]
[string]$TemplateVersion,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
               ParameterType = 'array'
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  c7f1dd1c7a383e5ee45acc2292201245


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Parameters



.PARAMETER ResourceType



.PARAMETER TemplateKind



.PARAMETER TemplatePath



.PARAMETER TemplateVersion



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$ResourceType,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  2fb20d2e3396e6132615a2099c071509


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Environment



.PARAMETER Group



.PARAMETER ResourceType



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$ResourceType,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ResourceType = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  8d4064540d821f88b18ed2ccfb7d2e7f


.DESCRIPTION See help for rad

.PARAMETER ResourceType



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusResource

Lists resources
Original Command: rad resource list


#>
}


function Get-RadiusResourceDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$ResourceType,
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ResourceType = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'show'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  f06af8da03a1da3978bf87057384a729


.DESCRIPTION See help for rad

.PARAMETER ResourceType



.PARAMETER Name



.PARAMETER Application



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusResourceDetail

Show Radius resource details
Original Command: rad resource show


#>
}


function Get-RadiusResourceLogs
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$ResourceType,
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Container,
[Parameter()]
[switch]$Follow,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Replica,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ResourceType = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Name = @{
               OriginalName = ''
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
               ParameterType = 'switch'
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  e217634df43d8060de617dbf5ce85417


.DESCRIPTION See help for rad

.PARAMETER ResourceType



.PARAMETER Name



.PARAMETER Container



.PARAMETER Follow



.PARAMETER Group



.PARAMETER Replica



.PARAMETER Application



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$ResourceType,
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[switch]$Yes,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         ResourceType = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Name = @{
               OriginalName = ''
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
         Yes = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  ac2b61eeb546387f26652790d7e8c080


.DESCRIPTION See help for rad

.PARAMETER ResourceType



.PARAMETER Name



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Yes



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$File,
[Parameter()]
[string]$Application,
[Parameter()]
[string]$Environment,
[Parameter()]
[string]$Group,
[Parameter()]
[array]$Parameters,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         File = @{
               OriginalName = ''
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
               ParameterType = 'array'
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  0854d011601005c1fa1943f7560763e9


.DESCRIPTION See help for rad

.PARAMETER File



.PARAMETER Application



.PARAMETER Environment



.PARAMETER Group



.PARAMETER Parameters



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[string]$KubeContext,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  e5e14cc8a173162ee44a58bb24107062


.DESCRIPTION See help for rad

.PARAMETER KubeContext



.PARAMETER Config



.PARAMETER Output




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
[switch]$CLI,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         CLI = @{
               OriginalName = '--cli'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  014ebf0fc1aa2e9c5a9745a731c4163e


.DESCRIPTION See help for rad

.PARAMETER CLI



.PARAMETER Config



.PARAMETER Output




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
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  975a6efe1d83f5b0d963bb4accc53f71


.DESCRIPTION See help for rad

.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusWorkspace

List local workspaces
Original Command: rad workspace list


#>
}


function Get-RadiusWorkspaceDetail
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
    $__commandArgs += 'show'
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  65d9c758adfec8f5ed62db591ddcff92


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Get-RadiusWorkspaceDetail

Show local workspace
Original Command: rad workspace show


#>
}


function New-RadiusWorkspaceKubernetes
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Context,
[Parameter()]
[string]$Environment,
[Parameter()]
[switch]$Force,
[Parameter()]
[string]$Group,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
               ParameterType = 'switch'
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  33e2f912f6e46e080d1da8c9af8523c1


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Context



.PARAMETER Environment



.PARAMETER Force



.PARAMETER Group



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




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
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Workspace,
[Parameter()]
[switch]$Yes,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Yes = @{
               OriginalName = '--yes'
               OriginalPosition = '0'
               Position = '2147483647'
               ParameterType = 'switch'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  06af99bd721263153612bbe02abf5142


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Workspace



.PARAMETER Yes



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Remove-RadiusWorkspace

Delete local workspaces
Original Command: rad workspace delete


#>
}


function Switch-RadiusWorkspace
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Mandatory=$true)]
[string]$Name,
[Parameter()]
[string]$Workspace,
[Parameter()]
[string]$Config,
[Parameter()]
[PSDefaultValue(Value="json")]
[string]$Output = "json"
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Name = @{
               OriginalName = ''
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
         Output = @{
               OriginalName = '--output'
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
        Default = @{ StreamOutput = $False; Handler = 'Parser' }
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
         Write-Verbose -Verbose -Message "rad"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("rad $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "rad")) {
          throw "Cannot find executable 'rad'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "rad" $__commandArgs
            }
            else {
                & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "rad" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
Error: unknown shorthand flag: '?' in -?

TraceId:  c2068f94f5db6c688184a121c2ad320f


.DESCRIPTION See help for rad

.PARAMETER Name



.PARAMETER Workspace



.PARAMETER Config



.PARAMETER Output




.EXAMPLE
PS> Switch-RadiusWorkspace

Switch current workspace
Original Command: rad workspace switch


#>
}


function Parser {
    param(
        [Parameter(Mandatory)]
        $cmdResults
    )

    $data = ($cmdResults | Out-String)

    if (Test-Json -Json $data -ErrorAction SilentlyContinue) {
        $data | ConvertFrom-Json
    }
    else {
        Write-Output $data



    }
}
