function global:ArgumentOutput {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdArguments
    )

    # Convert command results to lower case
    Write-Verbose -Message "Lowering $cmdArguments"
    return $cmdArguments.ToLower()
}

function global:ArgumentParameters {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdArguments
    )

    # Convert command results to a string
    return $cmdArguments.Values
}
