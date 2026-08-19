$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$components = @("views-settings","config-global","config-cameras","common","views-system","objects","views-exports","views-search")

$totalChecks = 0

foreach ($comp in $components) {
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/units/?format=json&page_size=100&q=has:check"
    $allUnits = @()
    while ($url) {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        $allUnits += $resp.results
        $url = $resp.next
    }
    
    $totalChecks += $allUnits.Count
    Write-Output "=== $comp ($($allUnits.Count) checks) ==="
    foreach ($u in $allUnits) {
        $src = if ($u.source -is [array]) { $u.source -join " | " } else { $u.source }
        $tgt = if ($u.target -is [array]) { $u.target -join " | " } else { $u.target }
        Write-Output "  [$($u.id)] $($u.context)"
        Write-Output "    src: $src"
        Write-Output "    tgt: $tgt"
        Write-Output "    url: $($u.web_url)"
        Write-Output ""
    }
}

Write-Output "Total checks across all components: $totalChecks"
