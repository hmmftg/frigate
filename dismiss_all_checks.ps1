$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

$components = @("views-settings","config-global","config-cameras","common","views-system","objects","views-exports","views-search")

$processed = 0
$failed = 0

foreach ($comp in $components) {
    Write-Output "Processing $comp..."
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/units/?format=json&page_size=100&q=has:check"
    while ($url) {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        foreach ($u in $resp.results) {
            $sourceUnitUrl = $u.source_unit
            if (-not $sourceUnitUrl) { continue }
            
            # Get current source unit
            try {
                $sourceUnit = Invoke-RestMethod -Uri "$($sourceUnitUrl)?format=json" -Headers $headers -Method Get
                $existingFlags = $sourceUnit.extra_flags
                
                # Add ignore flags if not already present
                $newFlags = $existingFlags
                if (-not $newFlags) { $newFlags = "ignore-inconsistent,ignore-unchanged" }
                elseif (-not $newFlags.Contains("ignore-inconsistent")) { $newFlags = "$newFlags,ignore-inconsistent,ignore-unchanged" }
                else { continue } # Already has flags
                
                $body = @{ extra_flags = $newFlags } | ConvertTo-Json
                Invoke-RestMethod -Uri "$($sourceUnitUrl)?format=json" -Headers $headers -Method Patch -Body $body | Out-Null
                $processed++
                Start-Sleep -Milliseconds 50
            } catch {
                $failed++
                Write-Output "FAIL: unit=$($u.id) error=$($_.Exception.Message)"
            }
        }
        $url = $resp.next
    }
}

Write-Output "Done: processed=$processed failed=$failed"
