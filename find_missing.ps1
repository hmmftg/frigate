function Get-FlatKeys($obj, $prefix="") {
    $keys = @()
    foreach ($k in $obj.PSObject.Properties.Name) {
        $fullKey = if ($prefix) { "$prefix.$k" } else { $k }
        if ($obj.$k -is [System.Management.Automation.PSCustomObject]) {
            $keys += Get-FlatKeys $obj.$k $fullKey
        } else {
            $keys += $fullKey
        }
    }
    return $keys
}

function Get-ValueByPath($obj, $path) {
    $parts = $path -split '\.'
    $current = $obj
    foreach ($p in $parts) {
        $current = $current.$p
    }
    return $current
}

function Set-ValueByPath($obj, $path, $value) {
    $parts = $path -split '\.'
    $current = $obj
    for ($i = 0; $i -lt $parts.Length - 1; $i++) {
        $current = $current.($parts[$i])
    }
    $current | Add-Member -NotePropertyName $parts[-1] -NotePropertyValue $value -Force
}

# Process views-settings.json
$enFile = "web\public\locales\en\views\settings.json"
$faFile = "web\public\locales\fa\views\settings.json"

$en = Get-Content $enFile -Raw | ConvertFrom-Json -Depth 20
$fa = Get-Content $faFile -Raw | ConvertFrom-Json -Depth 20

$enKeys = Get-FlatKeys $en
$faKeys = Get-FlatKeys $fa

$missing = $enKeys | Where-Object { $_ -notin $faKeys }
$extra = $faKeys | Where-Object { $_ -notin $enKeys }

Write-Output "views-settings: EN=$($enKeys.Count) FA=$($faKeys.Count) MISSING=$($missing.Count) EXTRA=$($extra.Count)"
Write-Output ""
Write-Output "MISSING KEYS (first 100):"
$missing | Select-Object -First 100 | ForEach-Object { Write-Output "  $_" }
if ($missing.Count -gt 100) { Write-Output "  ... and $($missing.Count - 100) more" }
Write-Output ""
Write-Output "EXTRA KEYS:"
$extra | ForEach-Object { Write-Output "  $_" }
