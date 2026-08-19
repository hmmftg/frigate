$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

# Get checks for views-settings
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/views-settings/fa/checks/?format=json&page_size=100"
$allChecks = @()
while ($url) {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $allChecks += $resp.results
    $url = $resp.next
}

# Group by check name
$groups = $allChecks | Group-Object name | Sort-Object Count -Descending
foreach ($g in $groups) {
    Write-Output ("{0}: {1}" -f $g.Name, $g.Count)
}
