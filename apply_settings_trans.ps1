# Load translations JSON
$transMap = Get-Content "settings_translations.json" -Raw | ConvertFrom-Json -AsHashtable

# Read the Persian settings file
$filePath = (Resolve-Path "web\public\locales\fa\views\settings.json").Path
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.UTF8Encoding]::new($false))

$replaced = 0
$notFound = 0

foreach ($en in $transMap.Keys) {
    $fa = $transMap[$en]
    
    # Escape for JSON string matching (handle quotes and backslashes)
    $enJson = $en -replace '\\', '\\' -replace '"', '\"'
    $faJson = $fa -replace '\\', '\\' -replace '"', '\"'
    
    if ($content.Contains($enJson)) {
        $content = $content.Replace($enJson, $faJson)
        $replaced++
    } else {
        $notFound++
        Write-Output "NOT FOUND: $en"
    }
}

# Write back
[System.IO.File]::WriteAllText($filePath, $content, [System.Text.UTF8Encoding]::new($false))
Write-Output "Replaced $replaced values, $notFound not found"
