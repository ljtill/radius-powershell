function global:Parser {
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        $cmdResults
    )

    if ($cmdResults) {
        # Convert the command results to a string
        $result = $cmdResults | Out-String

        # Check if the result is valid JSON
        if (Test-Json -Json $result -ErrorAction SilentlyContinue) {
            Write-Verbose "Converting JSON data"
            # Convert valid JSON to a PowerShell object
            return $result | ConvertFrom-Json
        }
        else {
            # Check if the result contains an error message
            if ($result -match 'Error: (?<ErrorMessage>.+)') {
                # Extract the error message
                $errorMessage = $matches['ErrorMessage']

                # Try to extract the TraceId from the result
                $traceId = $null
                $result -match 'TraceId: (?<TraceId>.+)' | Out-Null
                if ($matches['TraceId']) {
                    $traceId = $matches['TraceId']
                }

                # Create a custom exception message with explicit line breaks
                $exceptionMessage = "$errorMessage"
                if ($traceId) {
                    Write-Verbose "TraceId: $traceId"
                }

                # Throw an exception with the custom error message
                throw "$exceptionMessage"
            }
            else {
                # If it's not JSON or an error message, assume it's standard output
                # return ($result -split "`n")
                return $result.Trim("`r", "`n")
            }
        }
    }
    else {
        # Handle the case where command results are null
        Write-Verbose "Command results are null"
        return
    }
}
