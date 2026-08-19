function Merge-Json($en, $fa) {
    $result = [ordered]@{}
    foreach ($prop in $en.PSObject.Properties) {
        $key = $prop.Name
        $enVal = $prop.Value
        if ($fa.PSObject.Properties.Name -contains $key) {
            $faVal = $fa.$key
            if ($enVal -is [System.Management.Automation.PSCustomObject] -and $faVal -is [System.Management.Automation.PSCustomObject]) {
                $result[$key] = Merge-Json $enVal $faVal
            } else {
                $result[$key] = $faVal
            }
        } else {
            $result[$key] = $enVal
        }
    }
    return [PSCustomObject]$result
}

# Process views-settings.json
$en = Get-Content "web\public\locales\en\views\settings.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\views\settings.json" -Raw | ConvertFrom-Json -Depth 30

$merged = Merge-Json $en $fa
$json = $merged | ConvertTo-Json -Depth 30
[System.IO.File]::WriteAllText((Resolve-Path "web\public\locales\fa\views\settings.json").Path, $json, [System.Text.UTF8Encoding]::new($false))
Write-Output "views-settings.json merged"

# Process config-global.json
$en2 = Get-Content "web\public\locales\en\config\global.json" -Raw | ConvertFrom-Json -Depth 30
$fa2 = Get-Content "web\public\locales\fa\config\global.json" -Raw | ConvertFrom-Json -Depth 30

$merged2 = Merge-Json $en2 $fa2
$json2 = $merged2 | ConvertTo-Json -Depth 30
[System.IO.File]::WriteAllText((Resolve-Path "web\public\locales\fa\config\global.json").Path, $json2, [System.Text.UTF8Encoding]::new($false))
Write-Output "config-global.json merged"
