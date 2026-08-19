$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Read a unit to see what flags look like
$url = "https://hosted.weblate.org/api/units/152349483/?format=json"
$resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
Write-Output "flags: '$($resp.flags)'"
Write-Output "extra_flags: '$($resp.extra_flags)'"
Write-Output "source: $($resp.source)"
Write-Output "target: $($resp.target)"

# Try "ignore-same" flag
$url2 = "https://hosted.weblate.org/api/units/152349483/?format=json"
$body = '{"extra_flags": "ignore-same"}'
try {
    $resp2 = Invoke-RestMethod -Uri $url2 -Headers $headers -Method Patch -Body $body
    Write-Output "ignore-same: OK flags=$($resp2.extra_flags)"
} catch {
    $errDetail = $_.ErrorDetails.Message
    Write-Output "ignore-same: ERROR - $errDetail"
}
