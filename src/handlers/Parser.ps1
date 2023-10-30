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
            $pattern = [regex]::Match($result, '(?s)Error: (?<ErrorMessage>.*?)(?=\nTrace|$)')

            if ($pattern.Success) {
                # Extract the error message and replace newline characters
                $errorMessage = $pattern.Groups['ErrorMessage'].Value

                if (Test-Json -Json $errorMessage -ErrorSilentlyContinue) {
                    $errorMessage = ($errorMessage | ConvertFrom-Json).message
                }

                # Try to extract the TraceId from the result
                $pattern = [regex]::Match($result, 'TraceId: (?<TraceId>.+)')

                # Write the trace id to the verbose stream
                if ($pattern.Success) {
                    $traceId = $pattern.Groups['TraceId'].Value
                    Write-Verbose "TraceId: $traceId"
                }

                # Throw an exception with the custom error message
                throw "$errorMessage"
            }
            else {
                # If it's not JSON or an error message, assume it's standard output
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
