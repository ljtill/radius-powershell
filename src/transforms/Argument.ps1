function global:ArgumentOutput {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdArgument
    )

    process {
        # Convert command results to lower case
        Write-Output $cmdArgument.ToLower()
    }
}

function global:ArgumentParameters {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdArgument
    )

    process {
        # Iterate through the hashtable
        $cmdArgument.GetEnumerator() | ForEach-Object {
            $key = $_.Key
            $value = $_.Value

            # Output in the format "--parameters key=value"
            Write-Output "--parameters"
            Write-Output "$key=$value"
        }
    }
}

function global:ArgumentType {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdArgument
    )

    process {
        # Lower the first letter and join the rest of the string
        Write-Output $($cmdArgument.Substring(0, 1).ToLower() + $cmdArgument.Substring(1))
    }
}
