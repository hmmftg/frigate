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

$files = @(
    @{en="web\public\locales\en\config\global.json"; fa="web\public\locales\fa\config\global.json"; comp="config-global"},
    @{en="web\public\locales\en\config\cameras.json"; fa="web\public\locales\fa\config\cameras.json"; comp="config-cameras"}
)

foreach ($f in $files) {
    $en = Get-Content $f.en -Raw | ConvertFrom-Json
    $fa = Get-Content $f.fa -Raw | ConvertFrom-Json
    $enKeys = Get-FlatKeys $en
    $faKeys = Get-FlatKeys $fa
    $missing = ($enKeys | Where-Object { $_ -notin $faKeys })
    $extra = ($faKeys | Where-Object { $_ -notin $enKeys })
    Write-Output "$($f.comp): EN=$($enKeys.Count) FA=$($faKeys.Count) MISSING=$($missing.Count) EXTRA=$($extra.Count)"
    if ($missing.Count -gt 0 -and $missing.Count -le 80) {
        Write-Output "MISSING:"
        $missing | ForEach-Object { Write-Output "  $_" }
    }
    if ($extra.Count -gt 0 -and $extra.Count -le 30) {
        Write-Output "EXTRA:"
        $extra | ForEach-Object { Write-Output "  $_" }
    }
}
