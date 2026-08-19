# Load translations
$transMap = Get-Content "settings_translations.json" -Raw | ConvertFrom-Json -AsHashtable

# Load both files
$en = Get-Content "web\public\locales\en\views\settings.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\views\settings.json" -Raw | ConvertFrom-Json -Depth 30

# Recursively translate values: only replace leaf string values where fa==en and en is in transMap
function Translate-Values($enObj, $faObj) {
    foreach ($key in $enObj.PSObject.Properties.Name) {
        if ($faObj.PSObject.Properties.Name -contains $key) {
            $enVal = $enObj.$key
            $faVal = $faObj.$key
            if ($enVal -is [System.Management.Automation.PSCustomObject] -and $faVal -is [System.Management.Automation.PSCustomObject]) {
                Translate-Values $enVal $faVal
            } elseif ($enVal -is [string] -and $faVal -is [string] -and $enVal -eq $faVal) {
                # Untranslated - check if we have a translation
                if ($transMap.ContainsKey($enVal)) {
                    $faObj.$key = $transMap[$enVal]
                }
            }
        }
    }
}

Translate-Values $en $fa

# Write back with proper formatting
$json = $fa | ConvertTo-Json -Depth 30
[System.IO.File]::WriteAllText((Resolve-Path "web\public\locales\fa\views\settings.json").Path, $json, [System.Text.UTF8Encoding]::new($false))
Write-Output "Done"
