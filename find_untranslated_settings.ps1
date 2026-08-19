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

# views-settings.json
$en = Get-Content "web\public\locales\en\views\settings.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\views\settings.json" -Raw | ConvertFrom-Json -Depth 30

$enKv = Get-FlatKv $en
$faKv = Get-FlatKv $fa

$untranslated = @()
foreach ($key in $enKv.Keys) {
    if ($faKv.ContainsKey($key) -and $faKv[$key] -eq $enKv[$key]) {
        $untranslated += $key
    }
}

Write-Output "views-settings: Total=$($enKv.Count) Untranslated=$($untranslated.Count)"
$untranslated | ForEach-Object { Write-Output "  $_ = $($enKv[$_])" }
