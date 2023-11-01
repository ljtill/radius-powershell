function global:ArgumentOutput {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdResults
    )

    # Convert command results to lower case
    return $cmdResults.ToLower()
}

function global:ArgumentParameters {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdResults
    )

    # Convert command results to a string
    return $cmdResults.Values
}
