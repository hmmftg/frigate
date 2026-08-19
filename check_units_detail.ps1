$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

# Get units with failing checks for views-settings
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/views-settings/fa/units/?format=json&page_size=100&q=has:check"
$allUnits = @()
while ($url) {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $allUnits += $resp.results
    $url = $resp.next
}

Write-Output "Total units with checks: $($allUnits.Count)"
foreach ($u in $allUnits) {
    Write-Output "  id=$($u.id) ctx=$($u.context)"
    Write-Output "    src: $($u.source)"
    Write-Output "    tgt: $($u.target)"
    Write-Output "    checks: $($u.checks -join ', ')"
    Write-Output ""
}
