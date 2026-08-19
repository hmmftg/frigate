function Get-FlatKv($obj, $prefix="") {
    $kv = @{}
    foreach ($k in $obj.PSObject.Properties.Name) {
        $fullKey = if ($prefix) { "$prefix.$k" } else { $k }
        if ($obj.$k -is [System.Management.Automation.PSCustomObject]) {
            $kv += Get-FlatKv $obj.$k $fullKey
        } else {
            $kv[$fullKey] = $obj.$k
        }
    }
    return $kv
}

# config-global.json
$en = Get-Content "web\public\locales\en\config\global.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\config\global.json" -Raw | ConvertFrom-Json -Depth 30

$enKv = Get-FlatKv $en
$faKv = Get-FlatKv $fa

$untranslated = @()
foreach ($key in $enKv.Keys) {
    if ($faKv[$key] -eq $enKv[$key]) {
        $untranslated += $key
    }
}

Write-Output "config-global: Total=$($enKv.Count) Untranslated=$($untranslated.Count)"
$untranslated | ForEach-Object { Write-Output "  $_ = $($enKv[$_])" }
