$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Load local files
$faFile = "web\public\locales\fa\config\cameras.json"
$enFile = "web\public\locales\en\config\cameras.json"

$fa = Get-Content $faFile -Raw | ConvertFrom-Json -Depth 30
$en = Get-Content $enFile -Raw | ConvertFrom-Json -Depth 30

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

$faKv = Get-FlatKv $fa
$enKv = Get-FlatKv $en

# Fetch all units from Weblate
Write-Output "Fetching units from Weblate..."
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/config-cameras/fa/units/?format=json&page_size=100"
$allUnits = @()
while ($url) {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $allUnits += $resp.results
    $url = $resp.next
}
Write-Output "Total units fetched: $($allUnits.Count)"

$updated = 0
$failed = 0

foreach ($u in $allUnits) {
    $ctx = $u.context
    if (-not $faKv.ContainsKey($ctx)) { continue }
    
    $persianVal = $faKv[$ctx]
    $enVal = $enKv[$ctx]
    
    # Skip if local file still has English (untranslated/proper nouns)
    if ($persianVal -eq $enVal) { continue }
    
    # Get current Weblate target
    $weblateTarget = if ($u.target -is [array]) { $u.target -join "" } else { $u.target }
    
    # Skip if already correct
    if ($weblateTarget -eq $persianVal) { continue }
    
    # Patch
    $body = @{ target = @($persianVal); state = 20 } | ConvertTo-Json -Depth 5
    $unitUrl = "https://hosted.weblate.org/api/units/$($u.id)/?format=json"
    try {
        Invoke-RestMethod -Uri $unitUrl -Headers $headers -Method Patch -Body $body | Out-Null
        $updated++
        if ($updated % 50 -eq 0) { Write-Output "Updated $updated units..." }
        Start-Sleep -Milliseconds 50
    } catch {
        $failed++
        Write-Output "FAILED: id=$($u.id) ctx=$ctx error=$($_.Exception.Message)"
    }
}

Write-Output "Done: updated=$updated failed=$failed"
