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

$en = Get-Content "web\public\locales\en\views\settings.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\views\settings.json" -Raw | ConvertFrom-Json -Depth 30

$enKeys = Get-FlatKeys $en
$faKeys = Get-FlatKeys $fa

$missingInFa = @()
$extraInFa = @()
foreach ($k in $enKeys) { if ($k -notin $faKeys) { $missingInFa += $k } }
foreach ($k in $faKeys) { if ($k -notin $enKeys) { $extraInFa += $k } }

Write-Output "Missing in FA ($($missingInFa.Count)):"
foreach ($k in $missingInFa) { Write-Output "  $k" }
Write-Output ""
Write-Output "Extra in FA ($($extraInFa.Count)):"
foreach ($k in $extraInFa) { Write-Output "  $k" }
