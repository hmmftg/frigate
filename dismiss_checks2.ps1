$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Try to add ignore flags to proper noun units
$ids = @(152349483, 152349489, 152359693, 175758738)

foreach ($id in $ids) {
    $url = "https://hosted.weblate.org/api/units/$id/?format=json"
    $body = '{"extra_flags": "ignore-unchanged"}'
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        Write-Output "unit $id : OK flags=$($resp.extra_flags)"
    } catch {
        $errDetail = $_.ErrorDetails.Message
        Write-Output "unit $id : ERROR - $errDetail"
    }
}
