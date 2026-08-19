$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$components = @("common","components-dialog","config-cameras","objects","views-classificationmodel","views-exports","views-motionsearch","views-search","views-system")

foreach ($comp in $components) {
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/units/?format=json&page_size=100"
    $allUnits = @()
    while ($url) {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        $allUnits += $resp.results
        $url = $resp.next
    }
    
    $failing = $allUnits | Where-Object { $_.has_failing_check -eq $true }
    Write-Output "=== $comp ($($failing.Count) failing checks out of $($allUnits.Count) units) ==="
    foreach ($u in $failing) {
        Write-Output "  id=$($u.id) ctx=$($u.context)"
        Write-Output "    src: $($u.source)"
        Write-Output "    tgt: $($u.target)"
    }
}
