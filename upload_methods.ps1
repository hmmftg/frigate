$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

# Try different upload methods
$file = (Resolve-Path "web\public\locales\fa\config\cameras.json").Path
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/config-cameras/fa/file/"

# Try method=translate
$form = @{
    file = Get-Item $file
    method = "translate"
}

try {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Form $form
    Write-Output "method=translate: accepted=$($resp.accepted) total=$($resp.total) not_found=$($resp.not_found)"
} catch {
    $errDetail = $_.ErrorDetails.Message
    Write-Output "method=translate: ERROR - $errDetail"
}

# Try method=add
$form2 = @{
    file = Get-Item $file
    method = "add"
}

try {
    $resp2 = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Form $form2
    Write-Output "method=add: accepted=$($resp2.accepted) total=$($resp2.total) not_found=$($resp2.not_found)"
} catch {
    $errDetail2 = $_.ErrorDetails.Message
    Write-Output "method=add: ERROR - $errDetail2"
}
