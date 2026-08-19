$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$components = @("views-settings","config-global","config-cameras","common","views-system","objects","views-exports","views-search")

foreach ($comp in $components) {
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/units/?format=json&page_size=100&q=has:check"
    $allUnits = @()
    while ($url) {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        $allUnits += $resp.results
        $url = $resp.next
    }
    
    Write-Output "=== $comp ($($allUnits.Count) checks) ==="
    foreach ($u in $allUnits) {
        Write-Output "  id=$($u.id) ctx=$($u.context)"
        Write-Output "    src: $($u.source)"
        Write-Output "    tgt: $($u.target)"
    }
}
