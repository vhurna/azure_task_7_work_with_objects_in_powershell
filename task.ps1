# task.ps1

<#
.SYNOPSIS
    Searches Azure region JSON files for availability of the Standard_B2pts_v2 VM size and outputs matching regions to result.json.
#>
param(
    [string]$DataDir = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -ChildPath 'data'),
    [string]$OutputFile = (Join-Path -Path (Split-Path -Path $MyInvocation.MyCommand.Path -Parent) -ChildPath 'result.json')
)

# Stop execution on any error
$ErrorActionPreference = 'Stop'

Write-Host "Using data directory: $DataDir"
Write-Host "Result will be saved to: $OutputFile"

# Verify data directory exists
if (-not (Test-Path -Path $DataDir -PathType Container)) {
    throw "Data directory '$DataDir' not found."
}

# Initialize a list to collect matching regions
$regions = [System.Collections.Generic.List[string]]::new()

# Loop through each JSON file in the data directory
Get-ChildItem -Path $DataDir -Filter '*.json' -File | ForEach-Object {
    $file = $_
    Write-Host "Processing file: $($file.Name)"

    # Read raw JSON content and convert
    try {
        $raw = Get-Content -Path $file.FullName -Raw -ErrorAction Stop
        $entries = $raw | ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Warning "Skipping file '$($file.Name)' due to parse errors: $_"
        return
    }

    # Check for the desired VM size
    if ($entries | Where-Object { $_.Name -eq 'Standard_B2pts_v2' }) {
        Write-Host "  -> Found Standard_B2pts_v2 in region: $($file.BaseName)"
        $regions.Add($file.BaseName)
    }
}

# Sort the list of regions alphabetically
$regions = $regions | Sort-Object

# Export matching regions to JSON
$regions | ConvertTo-Json -Depth 1 | Set-Content -Path $OutputFile -Encoding UTF8

Write-Host "Done. Found $($regions.Count) region(s)."
