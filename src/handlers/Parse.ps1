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
