# task.ps1

<##
.SYNOPSIS
    Searches Azure region JSON files for availability of the Standard_B2pts_v2 VM size and outputs matching regions to result.json.
#>
param(
    [string]$DataDir     = (Join-Path -Path $PSScriptRoot -ChildPath 'data'),
    [string]$OutputFile  = (Join-Path -Path $PSScriptRoot -ChildPath 'result.json')
)

# Stop execution on error
$ErrorActionPreference = 'Stop'

Write-Host "Using data directory: $DataDir"
Write-Host "Result will be saved to: $OutputFile"

# Ensure data directory exists
if (-not (Test-Path -Path $DataDir -PathType Container)) {
    throw "Data directory '$DataDir' not found."
}

# Initialize array for matching regions
$regions = @()

# Process each JSON file in the data folder
Get-ChildItem -Path $DataDir -Filter '*.json' -File | ForEach-Object {
    $file = $_
    Write-Host "Processing file: $($file.Name)"
    try {
        $entries = Get-Content -Path $file.FullName -Raw -ErrorAction Stop |
                   ConvertFrom-Json -ErrorAction Stop
    } catch {
        Write-Warning "Skipping file '$($file.Name)' due to parse errors: $_"
        return
    }

    # If Standard_B2pts_v2 is available, add region
    if ($entries | Where-Object { $_.Name -eq 'Standard_B2pts_v2' }) {
        Write-Host "  -> Found Standard_B2pts_v2 in region: $($file.BaseName)"
        $regions += $file.BaseName
    }
}

# Sort results
$regions = $regions | Sort-Object

# Export to result.json
$regions | ConvertTo-Json -Depth 1 |
    Set-Content -Path $OutputFile -Encoding UTF8

Write-Host "Done. Found $($regions.Count) region(s)."
