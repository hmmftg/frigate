# Merge missing keys from English into Persian, translate values, remove extra keys
$transMap = Get-Content "settings_translations.json" -Raw | ConvertFrom-Json -AsHashtable

$en = Get-Content "web\public\locales\en\views\settings.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\views\settings.json" -Raw | ConvertFrom-Json -Depth 30

# Recursively merge: add missing keys from en to fa, translate if possible
function Merge-Translate($enObj, $faObj, $path="") {
    foreach ($key in @($enObj.PSObject.Properties.Name)) {
        $enVal = $enObj.$key
        $fullPath = if ($path) { "$path.$key" } else { $key }
        
        if ($faObj.PSObject.Properties.Name -contains $key) {
            # Key exists in both
            $faVal = $faObj.$key
            if ($enVal -is [System.Management.Automation.PSCustomObject] -and $faVal -is [System.Management.Automation.PSCustomObject]) {
                Merge-Translate $enVal $faVal $fullPath
            } elseif ($enVal -is [string] -and $faVal -is [string] -and $enVal -eq $faVal) {
                # Untranslated - apply translation if available
                if ($transMap.ContainsKey($enVal)) {
                    $faObj.$key = $transMap[$enVal]
                }
            }
        } else {
            # Key missing in fa - add it
            if ($enVal -is [System.Management.Automation.PSCustomObject]) {
                # Deep copy the object
                $newObj = [PSCustomObject]@{}
                Merge-Translate $enVal $newObj $fullPath
                $faObj | Add-Member -MemberType NoteProperty -Name $key -Value $newObj
            } else {
                # String value - translate if possible, otherwise use English
                $val = if ($transMap.ContainsKey($enVal)) { $transMap[$enVal] } else { $enVal }
                $faObj | Add-Member -MemberType NoteProperty -Name $key -Value $val
            }
        }
    }
}

Merge-Translate $en $fa

# Write back
$json = $fa | ConvertTo-Json -Depth 30
[System.IO.File]::WriteAllText((Resolve-Path "web\public\locales\fa\views\settings.json").Path, $json, [System.Text.UTF8Encoding]::new($false))
Write-Output "Merge and translate done"
