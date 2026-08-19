$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Load the Persian translation file
$faFile = "web\public\locales\fa\config\global.json"
$enFile = "web\public\locales\en\config\global.json"

$fa = Get-Content $faFile -Raw | ConvertFrom-Json -Depth 30
$en = Get-Content $enFile -Raw | ConvertFrom-Json -Depth 30

# Build a flat key->value map from the Persian file
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

# Find untranslated keys (Persian value == English value)
$untranslated = @()
foreach ($key in $enKv.Keys) {
    if ($faKv.ContainsKey($key) -and $faKv[$key] -eq $enKv[$key]) {
        $untranslated += $key
    }
}

Write-Output "Untranslated keys in config-global.json: $($untranslated.Count)"

# Fetch all units from Weblate
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/config-global/fa/units/?format=json&page_size=100"
$allUnits = @()
while ($url) {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $allUnits += $resp.results
    $url = $resp.next
    Write-Output "Fetched $($allUnits.Count) units..."
}

Write-Output "Total units fetched: $($allUnits.Count)"

# Build a map of context -> unit
$unitMap = @{}
foreach ($u in $allUnits) {
    $unitMap[$u.context] = $u
}

# Find units to update (source == target, meaning untranslated)
$toUpdate = @()
foreach ($u in $allUnits) {
    $src = if ($u.source -is [array]) { $u.source -join "" } else { $u.source }
    $tgt = if ($u.target -is [array]) { $u.target -join "" } else { $u.target }
    if ($src -eq $tgt -and $u.translated -eq $true) {
        $toUpdate += $u
    }
}

Write-Output "Units to update (source==target): $($toUpdate.Count)"

# Now patch each unit with the Persian translation from the local file
$updated = 0
$failed = 0
foreach ($u in $toUpdate) {
    $ctx = $u.context
    if ($faKv.ContainsKey($ctx)) {
        $persianVal = $faKv[$ctx]
        $enVal = $enKv[$ctx]
        # Only update if the Persian value is different from English
        if ($persianVal -ne $enVal) {
            $target = if ($u.target -is [array]) { @($persianVal) } else { $persianVal }
            $body = @{ target = $target; state = 20 } | ConvertTo-Json -Depth 5
            $unitUrl = "https://hosted.weblate.org/api/units/$($u.id)/?format=json"
            try {
                $resp = Invoke-RestMethod -Uri $unitUrl -Headers $headers -Method Patch -Body $body
                $updated++
                if ($updated % 50 -eq 0) { Write-Output "Updated $updated units..." }
            } catch {
                $failed++
                Write-Output "FAILED: id=$($u.id) ctx=$ctx error=$($_.Exception.Message)"
            }
        }
    }
}

Write-Output "Done: updated=$updated failed=$failed"
